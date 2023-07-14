//
//  CoTabBarPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol CoTabBarPresenterProtocol: Presenter {
    func showAddRecord()
}

final class CoTabBarPresenter: CoTabBarPresenterProtocol {
    
    private weak var ui: CoTabBarUI?
    private let wireframe: CoTabBarWireframeProtocol
    private var storage: CoStorageProtocol
    
    init(ui: CoTabBarUI, wireframe: CoTabBarWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewDidAppear() {
        let result = storage.fetchRecords()
        switch result {
        case .success(let records):
            let strongPasswordNotify = CoNotification(message: String(format: "notify_have_strong_passwords".localized, records.getStrongPasswords().count), type: .success)
            let weakPasswordNotify = CoNotification(message: String(format: "notify_detected_weak_passwords".localized, records.getWeakPasswords().count), type: .danger)
            let reusedPasswordNotify = CoNotification(message: String(format: "notify_detected_reused_passwords".localized, records.getReusedPasswords().count), type: .warning)
            storage.notifications.append(contentsOf: [strongPasswordNotify, weakPasswordNotify, reusedPasswordNotify])
        case .failure:
            break
        }
    }
    
    func showAddRecord() {
        wireframe.navigate(to: .openRecordWith(id: nil))
    }
}
