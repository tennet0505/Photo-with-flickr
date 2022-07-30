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
        let unselectedfavImage = UIImage(systemName: "heart")
        let selectedfavImage = UIImage(systemName: "heart.fill")
        isFav = !isFav
        isFav ? favoriteButton.setImage(selectedfavImage, for: .normal) : favoriteButton.setImage(unselectedfavImage, for: .normal)
        callback?(isFav)
    }
}
