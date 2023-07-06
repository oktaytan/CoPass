//
//  UITableViewCell+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 7.07.2023.
//

import UIKit.UITableViewCell
import ViewAnimator

extension UITableViewCell {
    func setAnimation(index: Int) {
        let fromAnimation = AnimationType.from(direction: .left, offset: 100)
        UIView.animate(views: [self], animations: [fromAnimation], initialAlpha: 0.0, finalAlpha: 1.0, delay: (0.1 * Double(index)), duration: 0.25)
    }
}
