//
//  NotificationsPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 14.07.2023.
//

import Foundation

protocol NotificationsPresenterProtocol: Presenter {
    func goToSafety(entity: CoNotification)
}

final class NotificationsPresenter: NotificationsPresenterProtocol {
    
    private weak var ui: NotificationsUI?
    private let wireframe: NotificationsWireframeProtocol
    private var storage: CoStorageProtocol
    
    private var notifications = [CoNotification]()
    
    private var rows = [RowType]()
    
    init(ui: NotificationsUI, wireframe: NotificationsWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewWillAppear() {
        self.notifications = storage.notifications
        prepare()
    }
    
    func goToSafety(entity: CoNotification) {
        switch entity.type {
        case .success: wireframe.navigate(to: .goToSafety(group: .strong))
        case .danger: wireframe.navigate(to: .goToSafety(group: .weak))
        case .warning: wireframe.navigate(to: .goToSafety(group: .reused))
        }
        
        storage.removeNotificaiton(id: entity.id)
    }
}


extension NotificationsPresenter {
    private func prepare() {
        self.rows.removeAll()
        
        if self.notifications.isEmpty {
            self.rows.append(RowType.empty)
        } else {
            self.rows = storage.notifications.map { RowType.notification(entity: $0) }
        }
        
        self.ui?.load(notifications: self.rows)
    }
}


extension NotificationsPresenter {
    enum RowType {
        case notification(entity: CoNotification), empty
    }
}
