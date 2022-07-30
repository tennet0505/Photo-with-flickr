//
//  ViewController.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import UIKit
import SDWebImage
import ViewAnimator

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        getPhotos()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func setupViewModel() {
        apiService = ApiService()
        viewModel = MainViewModel(apiService: apiService)
        viewModel.mainViewModeldelegate = self
    }
    
    func setupUI() {
        navigationItem.searchController = searchBarController
        searchBarController.searchResultsUpdater = self
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "mainColor")]
    }
    
    func getPhotos() {
        photos.removeAll()
        viewModel.getPhotos(withRandomGallery: false)
    }
    
    func searchPhotosBy(_ text: String)  {
        viewModel.searchPhotosBy(text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToDetail",
            let vc = segue.destination as? DetailViewController {
            vc.selectedIndexPath = self.selectedIndexPath
            vc.photos = self.photos
        }
    }
    
    @IBAction func favoritesButton(_ sender: Any) {
        showFavorites = !showFavorites
        if showFavorites {
            self.favoritesButton.title = "Show all photos"
            self.photos = photos.filter{ $0.isFav == true }
            self.collectionView.reloadData()
        } else {
            self.favoritesButton.title = "Favorites"
            getPhotos()
        }
    }
    
    @IBAction func randomGalleryButton(_ sender: Any) {
        showAlertWith( title: "Oops!", message: "coming soon...")
//        photos.removeAll()
//        viewModel.getPhotos(withRandomGallery: true)
    }
    
}

//MARK: Delegates
extension ViewController: MainViewModeldelegate {
    func didStartRequest() {
        showHUD()
    }
    
    func didFinishLoading(photos: [PhotoElement]) {
        self.photos.removeAll()
        DispatchQueue.main.async {
            self.photos = photos
            self.collectionView.reloadData()
            let animation = AnimationType.from(direction: .top, offset: 30.0)
            UIView.animate(views: self.collectionView.visibleCells, animations: [animation], delay: 0, duration: 0.3)
        }
        dismissHUD(isAnimated: true)
    }
    
    func didFinishWith(Error: Error) {
        dismissHUD(isAnimated: true)
        showAlertWith(message: Error.localizedDescription)
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
        let unselectedfavImage = UIImage(systemName: "heart")
        let selectedfavImage = UIImage(systemName: "heart.fill")
        let photoItem = self.photos[indexPath.row]
        cell.image.sd_setImage(with: photoItem.urlImage)
        cell.isFav = photoItem.isFav ?? false
        (photoItem.isFav ?? false) ? cell.favButton.setImage(selectedfavImage, for: .normal) : cell.favButton.setImage(unselectedfavImage, for: .normal)
        cell.callback = { isFav in
            self.updateListOf(self.photos, with: photoItem.id, isFav: isFav)
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
