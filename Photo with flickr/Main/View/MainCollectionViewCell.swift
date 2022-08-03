//
//  MainCollectionViewCell.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var isFav = false
    var callback : ((Bool) -> ())?
    
    @IBAction func favButtonTap(_ sender: Any) {
        isFav = !isFav
        favButton.setupState(isFav: isFav)
        callback?(isFav)
    }
    
    func setupCellWith(_ photoItem: PhotoElement) {
        image.sd_setImage(with: photoItem.urlImage)
        isFav = photoItem.isFav ?? false
        favButton.setupState(isFav: photoItem.isFav ?? false)
    }
}

