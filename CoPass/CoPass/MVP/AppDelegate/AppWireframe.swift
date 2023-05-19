//
//  AppWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit

class AppWireframe: BaseWireframe {
    
    static let shared = AppWireframe()
    
    private override init() {}
    
    weak var window: UIWindow!
    
    func setRootVC(vc: UIViewController, _ window: UIWindow) {
        self.window = window
        let navController = UINavigationController(rootViewController: vc)
        forward(navController, with: .root(window: window))
        window.makeKeyAndVisible()
    }
    
}
