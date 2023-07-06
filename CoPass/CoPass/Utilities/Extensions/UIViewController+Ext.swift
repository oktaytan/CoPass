//
//  UIViewController+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.06.2023.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
}

// MARK: - Top Controller
extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
