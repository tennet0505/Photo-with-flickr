//
//  DetailViewController.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var zoomView: UIView!
    @IBOutlet weak var imageViewZoom: UIImageView!
    
    var photos: [PhotoElement] = []
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var isFavoriteGallery = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "mainColor")]
        navigationItem.title = isFavoriteGallery ? PhotoLocale.favorites : ""
        scrollToIndex(index: selectedIndexPath.row)
        zoomView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
    }
    
    func scrollToIndex(index:Int) {
        collectionView.isPagingEnabled = false
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            self.collectionView.isPagingEnabled = true
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewZoom
    }
    
    @IBAction func closeButton(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.zoomView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.zoomView.alpha = 0
        }) { (_) in
            self.navigationItem.title = self.isFavoriteGallery ? PhotoLocale.favorites : ""
            self.imageViewZoom.image = UIImage(named: "")
            self.zoomView.isHidden = true
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
        cell.nameLabel.text = photoItem.title
        cell.isFav = photoItem.isFav ?? false
        cell.favoriteButton.setupState(isFav:  photoItem.isFav ?? false)
        cell.callback = { isFav in
            self.updateListOf(self.photos, with: photoItem.id, isFav: isFav)
            if self.isFavoriteGallery {
                self.collectionView.deleteItems(at: [indexPath])
                self.photos.remove(at: indexPath.row)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoItem = self.photos[indexPath.row]
        imageViewZoom.sd_setImage(with: photoItem.urlImage)
        self.zoomView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.zoomView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.navigationItem.title = photoItem.title
            self.zoomView.transform = CGAffineTransform.identity
            self.zoomView.alpha = 1
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}
