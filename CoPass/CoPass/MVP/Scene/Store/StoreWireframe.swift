//
//  StoreWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol StoreWireframeProtocol: AnyObject {
    func navigate(to route: Router.Store)
}

final class StoreWireframe: BaseWireframe, StoreWireframeProtocol {
    
    static func prepare(category: CoCategory? = nil) -> StoreVC {
        let view = StoreVC(nibName: StoreVC.className, bundle: nil)
        let wireframe = StoreWireframe()
        let presenter = StorePresenter(ui: view, wireframe: wireframe, category: category, storage: CoStorage.shared)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Store) {
        
    }
}

extension StoreWireframe {
    
}
