//
//  StoreWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol StoreWireframeProtocol: AnyObject {
    func navigate(to route: Router.Store)
}

final class StoreWireframe: BaseWireframe, StoreWireframeProtocol {
    
    static func prepare(category: CoCategory? = nil) -> StoreVC {
        let view = StoreVC(nibName: StoreVC.className, bundle: nil)
        let wireframe = StoreWireframe()
        let presenter = StorePresenter(ui: view, wireframe: wireframe, category: category, storage: CoStorage.shared)
        let provider = StoreTableViewProviderImpl()
        view.inject(presenter: presenter, provider: provider)
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Store) {
        switch route {
        case .openRecordWith(let id):
            openRecordWith(id: id)
        }
    }
}

extension StoreWireframe {
    private func openRecordWith(id: NSManagedObjectID) {
        let recordVC = RecordWireframe.prepare(id: id)
        forward(recordVC, with: .pageSheet(from: self.view))
    }
}
