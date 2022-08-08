//
//  ViewController.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import UIKit
import SDWebImage
import ViewAnimator
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    @IBOutlet weak var randomGallery: UIBarButtonItem!
    
    let searchBarController = UISearchController()
    var viewModel: MainViewModel!
    var apiService: ApiService!
    var photos: [PhotoElement] = []
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var showFavorites = false
    var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        bindViewModel()
        getPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showFavorites {
            self.photos = photos.filter{ $0.isFav ?? true }
        }
        collectionView.reloadData()
    }
    
    fileprivate func bindViewModel() {
        viewModel.$results
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.dismissHUD(isAnimated: true)
                    self?.showAlertWith(message: error.localizedDescription)
                case .success(let photos):
                    self?.photos.removeAll()
                    self?.photos = photos.photos?.photo ?? []
                    self?.collectionView.reloadData()
                    let animation = AnimationType.from(direction: .top, offset: 30.0)
                    UIView.animate(views: self?.collectionView.visibleCells ?? [], animations: [animation], delay: 0, duration: 0.3)
                    self?.dismissHUD(isAnimated: true)
                case .none:
                    break
                }
            }.store(in: &cancellable)
    }
    
    func setupViewModel() {
        apiService = ApiService()
        viewModel = MainViewModel(apiService: apiService)
    }
    
    func setupUI() {
        navigationItem.searchController = searchBarController
        searchBarController.searchResultsUpdater = self
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "mainColor") ?? .lightGray]
    }
    
    func getPhotos() {
        photos.removeAll()
        showHUD()
        viewModel.make(apiRequest: .getPhoto(withRandomGallery: false))
    }
    
    func searchPhotosBy(_ text: String)  {
        viewModel.make(apiRequest: .searchPhotosBy(text))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToDetail",
           let vc = segue.destination as? DetailViewController {
            vc.selectedIndexPath = self.selectedIndexPath
            vc.photos = self.photos
            vc.isFavoriteGallery = showFavorites
        }
    }
    
    @IBAction func favoritesButton(_ sender: Any) {
        showFavorites = !showFavorites
        if showFavorites {
            self.favoritesButton.title = PhotoLocale.showAllPhotos
            self.photos = photos.filter{ $0.isFav == true }
            self.collectionView.reloadData()
        } else {
            self.favoritesButton.title = PhotoLocale.favorites
            getPhotos()
        }
    }
    
    @IBAction func randomGalleryButton(_ sender: Any) {
        showAlertWith( title: PhotoLocale.oops, message: PhotoLocale.comingSoon)
        //        photos.removeAll()
        //        viewModel.make(apiRequest: .getPhoto(withRandomGallery: true))
    }
    
}

//MARK: Search bar
extension ViewController: UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if text.count > 2 {
            searchPhotosBy(text)
        }
        if text.isEmpty {
            let queue = DispatchQueue(label: "queue", attributes: .concurrent)
            queue.async(flags: .barrier) {
                self.getPhotos()
            }
        }
    }
}

//MARK: Collection DataSource, Delegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        let photoItem = self.photos[indexPath.row]
        cell.setupCellWith(photoItem)
        cell.callback = { isFav in
            self.updateListOf(self.photos, with: photoItem.id, isFav: isFav)
            if self.showFavorites, !isFav {
                self.collectionView.deleteItems(at: [indexPath])
                self.photos.remove(at: indexPath.row)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "segueToDetail", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 32) / 4, height: (view.frame.width - 32) / 4)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}
