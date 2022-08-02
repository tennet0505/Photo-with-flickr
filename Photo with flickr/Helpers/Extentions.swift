//
//  Extentions.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 30/07/2022.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    func updateListOf(_ photos: [PhotoElement], with id: String, isFav: Bool) {
        photos.filter({$0.id == id}).first?.isFav = isFav
        if isFav {
            UserDefaultsHelper.shared.addNewFavoritPhotoWith(id)
        } else {
            UserDefaultsHelper.shared.removeFromFavoritPhotoWith(id)
        }
    }
    
    func showHUD(){
           DispatchQueue.main.async{
               MBProgressHUD.showAdded(to: self.view, animated: true)
           }
       }

       func dismissHUD(isAnimated:Bool) {
           DispatchQueue.main.async{
               MBProgressHUD.hide(for: self.view, animated: isAnimated)
           }
       }
    
    func showAlertWith(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: PhotoLocale.ok, style: .default))
        present(alert, animated: true, completion: nil)
    }
}

extension UIButton {
    func setupState(isFav: Bool) {
        let unselectedfavImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysTemplate)
        let selectedfavImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        isFav ? self.setImage(selectedfavImage, for: .normal) : self.setImage(unselectedfavImage, for: .normal)
        self.tintColor = isFav ? .red : .gray
    }
}
