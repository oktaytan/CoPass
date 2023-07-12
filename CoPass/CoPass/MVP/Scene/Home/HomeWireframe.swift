//
//  HomeWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import UIKit
import CoreData

protocol HomeWireframeProtocol: AnyObject {
    func navigate(to route: Router.Home)
}

final class HomeWireframe: BaseWireframe, HomeWireframeProtocol {
    
    static func prepare(delegate: HomeVCDelegate) -> HomeVC {
        let view = HomeVC(nibName: HomeVC.className, bundle: nil)
        let wireframe = HomeWireframe()
        let presenter = HomePresenter(ui: view, wireframe: wireframe, storage: CoStorage.shared)
        let provider = HomeTableViewProviderImpl()
        view.inject(presenter: presenter, provider: provider, delegate: delegate)
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Home) {
        switch route {
        case .goToStoreWith(let category):
            goToStore(with: category)
        case .openRecordWith(let id):
            openRecordWith(id: id)
        case .goToNotifications:
            goToNotifications()
        }
    }
}

extension HomeWireframe {
    private func goToStore(with category: CoCategory) {
        let storeVC = StoreWireframe.prepare(category: category)
        forward(storeVC, with: .push)
    }
    
    private func openRecordWith(id: NSManagedObjectID) {
        let recordVC = RecordWireframe.prepare(id: id)
        forward(recordVC, with: .pageSheet(from: self.view, detent: .large))
    }
    
    private func goToNotifications() {
        let notificationsVC = NotificationsVC(nibName: NotificationsVC.className, bundle: nil)
        forward(notificationsVC, with: .push)
    }
}
