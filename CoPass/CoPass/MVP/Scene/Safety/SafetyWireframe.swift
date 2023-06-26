//
//  SafetyWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol SafetyWireframeProtocol: AnyObject {
    func navigate(to route: Router.Safety)
}

final class SafetyWireframe: BaseWireframe, SafetyWireframeProtocol {
    
    static func prepare() -> SafetyVC {
        let view = SafetyVC(nibName: SafetyVC.className, bundle: nil)
        let wireframe = SafetyWireframe()
        let presenter = SafetyPresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Safety) {
        
    }
}

extension SafetyWireframe {
    
}
