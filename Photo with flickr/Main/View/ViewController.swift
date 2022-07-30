//
//  ViewController.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 29/07/2022.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: MainViewModel!
    var apiService: ApiService!
    var photos: [PhotoElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        getPhotos()
        
        
//        searchPhotosBy("gor")
    }
    
    func setupViewModel() {
        apiService = ApiService()
        viewModel = MainViewModel(apiService: apiService)
    }
    
    func getPhotos() {
        viewModel.getPhotos(
            complitionSuccess: { photos in
                self.photos.removeAll()
                DispatchQueue.main.async {
                    self.photos = photos
                    self.collectionView.reloadData()
                }
            }, complitionError: { error in
                print(error)
            })
    }
    
    func searchPhotosBy(_ text: String)  {
        viewModel.searchPhotosBy(text,
                                 complitionSuccess: { photos in
            self.photos.removeAll()
            self.photos = photos
        }, complitionError: { error in
            print(error)
        })
    }
}



extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCollectionViewCell
        
        let photoItem = self.photos[indexPath.row]
        cell.image.sd_setImage(with: photoItem.urlImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 32) / 4, height: (view.frame.width - 32) / 4)
    }
}
