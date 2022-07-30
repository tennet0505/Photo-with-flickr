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
        
        let photoItem = self.photos[indexPath.row]
        cell.imageView.sd_setImage(with: photoItem.urlImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
