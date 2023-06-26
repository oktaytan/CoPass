//
//  ProfileWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol ProfileWireframeProtocol: AnyObject {
    func navigate(to route: Router.Profile)
}

final class ProfileWireframe: BaseWireframe, ProfileWireframeProtocol {
    
    static func prepare() -> ProfileVC {
        let view = ProfileVC(nibName: ProfileVC.className, bundle: nil)
        let wireframe = ProfileWireframe()
        let presenter = ProfilePresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Profile) {
        
    }
}

extension ProfileWireframe {
    
}
