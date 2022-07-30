//
//  Extentions.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func updateListOf(_ photos: [PhotoElement], with id: String, isFav: Bool) {
        photos.filter({$0.id == id}).first?.isFav = isFav
        if isFav {
            UserDefaultsHelper.shared.addNewFavoritPhotoWith(id)
        } else {
            UserDefaultsHelper.shared.removeFromFavoritPhotoWith(id)
        }
    }
}
