//
//  RecordWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol RecordWireframeProtocol: AnyObject {
    func navigate(to route: Router.Record)
}

final class RecordWireframe: BaseWireframe, RecordWireframeProtocol {
    
    static func prepare() -> RecordVC {
        let view = RecordVC(nibName: RecordVC.className, bundle: nil)
        let wireframe = RecordWireframe()
        let presenter = RecordPresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Record) {
        
    }
}

extension RecordWireframe {
    
}
