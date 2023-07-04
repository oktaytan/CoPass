//
//  CoTabBarWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 25.06.2023.
//

import UIKit
import CoreData

protocol CoTabBarWireframeProtocol: AnyObject {
    func navigate(to route: Router.TabBar)
}

final class CoTabBarWireframe: BaseWireframe, CoTabBarWireframeProtocol {
    
    private var homeVC: HomeVC?
    private var storeVC: StoreVC?
    private var safetyVC: SafetyVC?
    private var profileVC: ProfileVC?
    
    static func prepare() -> CoTabBarVC {
        let view = CoTabBarVC()
        let wireframe = CoTabBarWireframe()
        let presenter = CoTabBarPresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        wireframe.setTabBar(with: view)
        return view
    }
    
    func navigate(to route: Router.TabBar) {
        switch route {
        case .home, .store, .safety, .profile:
            changeTabBar(with: route.index)
        case .openStoreWith(let category):
            openStoreWith(category: category)
        case .openRecordWith(let id):
            openRecordWith(id: id)
        }
    }
}

extension CoTabBarWireframe {
    private func openRecordWith(id: NSManagedObjectID?) {
        let recordVC = RecordWireframe.prepare(id: id)
        forward(recordVC, with: .modal(from: self.view))
    }
    
    private func openStoreWith(category: CoCategory) {
        let storeVC = StoreWireframe.prepare(category: category)
        forward(storeVC, with: .modal(from: self.view))
    }
}


extension CoTabBarWireframe {
    private func setTabBar(with view: UITabBarController) {
        let homeVC = HomeWireframe.prepare(delegate: self)
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
    
    private func changeTabBar(with index: Int) {
        guard let coTabBarVC = self.view as? CoTabBarVC else { return }
        coTabBarVC.changeTabBar(with: index)
    }
}


// MARK: - HomeVC Delegation
extension CoTabBarWireframe: HomeVCDelegate {
    func action(_ event: HomeVC.UserEvent) {
        switch event {
        case .goToProfile:
            navigate(to: .profile)
        case .goToSafetyScore:
            navigate(to: .safety)
        case .goToStore(let category):
            navigate(to: .openStoreWith(category: category))
        case .goToRecordWith(let id):
            navigate(to: .openRecordWith(id: id))
        }
    }
}
