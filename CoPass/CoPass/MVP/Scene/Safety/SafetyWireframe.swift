//
//  SafetyWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol SafetyWireframeProtocol: AnyObject {
    func navigate(to route: Router.Safety)
}

final class SafetyWireframe: BaseWireframe, SafetyWireframeProtocol {
    
    static func prepare(group: CoScoreGroup, from: CoRouteType) -> SafetyVC {
        let view = SafetyVC(nibName: SafetyVC.className, bundle: nil)
        let wireframe = SafetyWireframe()
        let presenter = SafetyPresenter(ui: view, wireframe: wireframe, selectedGroup: group, storage: CoStorage.shared)
        let provider = SafetyTableViewProviderImpl()
        view.inject(presenter: presenter, provider: provider, from: from)
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Safety) {
        switch route {
        case .openRecordWith(let id):
            openRecordWith(id: id)
        }
    }
}

extension SafetyWireframe {
    private func openRecordWith(id: NSManagedObjectID) {
        let recordVC = RecordWireframe.prepare(id: id)
        forward(recordVC, with: .modal(from: self.view))
    }
}
