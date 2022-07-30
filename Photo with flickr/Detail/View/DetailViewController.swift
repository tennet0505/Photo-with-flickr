//
//  DetailViewController.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [PhotoElement] = []
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollToIndex(index: selectedIndexPath.row)
        
    }
    
    func scrollToIndex(index:Int) {
        collectionView.isPagingEnabled = false
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.isPagingEnabled = true
        }
    }    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DetailCollectionViewCell
        let unselectedfavImage = UIImage(systemName: "heart")
        let selectedfavImage = UIImage(systemName: "heart.fill")
        let photoItem = self.photos[indexPath.row]
        cell.imageView.sd_setImage(with: photoItem.urlImage)
        cell.nameLabel.text = photoItem.title
        cell.isFav = photoItem.isFav ?? false
        (photoItem.isFav ?? false) ? cell.favoriteButton.setImage(selectedfavImage, for: .normal) : cell.favoriteButton.setImage(unselectedfavImage, for: .normal)
        cell.callback = { isFav in
            self.updateListOf(self.photos, with: photoItem.id, isFav: isFav)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}
