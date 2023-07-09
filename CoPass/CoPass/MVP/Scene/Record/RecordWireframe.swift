//
//  RecordWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol RecordWireframeProtocol: AnyObject {
    func navigate(to route: Router.Records)
}

final class RecordWireframe: BaseWireframe, RecordWireframeProtocol {
    
    static func prepare(id: NSManagedObjectID?) -> RecordVC {
        let view = RecordVC(nibName: RecordVC.className, bundle: nil)
        let wireframe = RecordWireframe()
        let status: RecordStatusType = id == nil ? .add : .update
        let presenter = RecordPresenter(ui: view, wireframe: wireframe, id: id, status: status, storage: CoStorage.shared)
        let provider = RecordTableViewProviderImpl()
        view.inject(presenter: presenter, provider: provider)
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Records) {
        switch route {
        case .dismiss:
            backward(animated: true)
        }
    }
}

extension RecordWireframe {
    
}
