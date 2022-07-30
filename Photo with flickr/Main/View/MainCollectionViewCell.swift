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
        let unselectedfavImage = UIImage(systemName: "heart")
        let selectedfavImage = UIImage(systemName: "heart.fill")
        isFav = !isFav
        isFav ? favButton.setImage(selectedfavImage, for: .normal) : favButton.setImage(unselectedfavImage, for: .normal)
        callback?(isFav)
    }
}
