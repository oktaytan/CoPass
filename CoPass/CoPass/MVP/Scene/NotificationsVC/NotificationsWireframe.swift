//
//  NotifcationsWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 14.07.2023.
//

import Foundation

protocol NotificationsWireframeProtocol: AnyObject {
    func navigate(to route: Router.Notifications)
}

final class NotificationsWireframe: BaseWireframe, NotificationsWireframeProtocol {
    
    static func prepare() -> NotificationsVC {
        let view = NotificationsVC(nibName: NotificationsVC.className, bundle: nil)
        let wireframe = NotificationsWireframe()
        let presenter = NotificationsPresenter(ui: view, wireframe: wireframe, storage: CoStorage.shared)
        let provider = NotificationsTableViewProviderImpl()
        view.inject(presenter: presenter, provider: provider)
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Notifications) {
        switch route {
        case .goToSafety(let group):
            goToSafety(group: group)
        }
    }
}

extension NotificationsWireframe {
    private func goToSafety(group: CoScoreGroup) {
        let safetyVC = SafetyWireframe.prepare(group: group, from: .push)
        forward(safetyVC, with: .push)
    }
}
