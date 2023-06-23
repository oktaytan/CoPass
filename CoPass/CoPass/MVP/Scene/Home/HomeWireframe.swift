//
//  HomeWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation

protocol HomeWireframeProtocol: AnyObject {
    func navigate(to route: Router.Home)
}

final class HomeWireframe: BaseWireframe, HomeWireframeProtocol {
    
    static func prepare() -> HomeVC {
        let view = HomeVC(nibName: HomeVC.className, bundle: nil)
        let wireframe = HomeWireframe()
        let presenter = HomePresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Home) {
        
    }
}

extension HomeWireframe {
    
}
