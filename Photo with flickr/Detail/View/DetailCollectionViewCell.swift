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
    @IBOutlet weak var likeWidthConstraint: NSLayoutConstraint!
    
    var isFav = false
    var callback : ((Bool) -> ())?
    private lazy var likeAnimator = LikeAnimator(container: self.contentView, layoutConstraint: likeWidthConstraint)
    
    @IBAction func favButtonTap(_ sender: Any) {
        stateSetup()
    }
    
    func setupCellWith(_ photoItem: PhotoElement) {
        imageView.sd_setImage(with: photoItem.urlImage)
        nameLabel.text = photoItem.title
        isFav = photoItem.isFav ?? false
        favoriteButton.setupState(isFav:  photoItem.isFav ?? false)
    }
    
    func animateHeartLike() {
        if !isFav {
            likeAnimator.animate{
                self.stateSetup()
            }
        }
    }
    
    func stateSetup() {
        isFav = !isFav
        favoriteButton.setupState(isFav: isFav)
        callback?(isFav)
    }
}
