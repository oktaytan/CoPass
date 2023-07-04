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
        let presenter = RecordPresenter(ui: view, wireframe: wireframe, id: id, storage: CoStorage.shared)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Records) {
        
    }
}

extension RecordWireframe {
    
}
