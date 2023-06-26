//
//  CoTabBarWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 25.06.2023.
//

import UIKit

protocol CoTabBarWireframeProtocol: AnyObject {
    func navigate(to route: Router.TabBar)
}

final class CoTabBarWireframe: BaseWireframe, CoTabBarWireframeProtocol {
    
    static func prepare() -> CoTabBarVC {
        let view = CoTabBarVC()
        let wireframe = CoTabBarWireframe()
        let presenter = CoTabBarPresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        self.setTabBar(with: view)
        return view
    }
    
    func navigate(to route: Router.TabBar) {
        switch route {
        case .showAddRecord:
            showAddRecord()
        }
    }
}

extension CoTabBarWireframe {
    private func showAddRecord() {
        let recordVC = RecordWireframe.prepare()
        forward(recordVC, with: .modal(from: self.view))
    }
}


extension CoTabBarWireframe {
    private static func setTabBar(with view: UITabBarController) {
        let homeVC = HomeWireframe.prepare()
        let storeVC = StoreWireframe.prepare()
        let safetyVC = SafetyWireframe.prepare()
        let profileVC = ProfileWireframe.prepare()
        
        view.viewControllers = [homeVC, storeVC, safetyVC, profileVC]
        view.selectedIndex = 0
        
        view.viewControllers?.enumerated().forEach({ (index, viewController) in
            let tabbarItem = UITabBarItem(title: nil, image: UIImage(named: "tabbar-\(index+1)")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tabbar-\(index+1)-selected")?.withRenderingMode(.alwaysOriginal))
            viewController.tabBarItem = tabbarItem
        })
    }
}
