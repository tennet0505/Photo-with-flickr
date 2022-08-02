//
//  DetailCollectionViewCell.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFav = false
    var callback : ((Bool) -> ())?
    
    @IBAction func favButtonTap(_ sender: Any) {
        isFav = !isFav
        favoriteButton.setupState(isFav: isFav)
        callback?(isFav)
    }
}
