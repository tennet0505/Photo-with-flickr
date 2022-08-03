//
//  Animation.swift
//  Photo with flickr
//
//  Created by Oleg Ten on 03/08/2022.
//

import Foundation
import UIKit

class LikeAnimator{
    
    var container = UIView()
    var layoutConstraint = NSLayoutConstraint()
    
    init(container: UIView, layoutConstraint: NSLayoutConstraint ) {
        self.container = container
        self.layoutConstraint = layoutConstraint
    }
    
    func animate(completion: @escaping () -> Void) {
        
        layoutConstraint.constant = 56
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2,
                       options: .curveLinear,
                       animations: { [weak self] in
                    
                        self?.container.layoutIfNeeded()
        }) { [weak self] (_) in
            
            self?.layoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self?.container.layoutIfNeeded()
                completion()
            }
        }
    }
}
