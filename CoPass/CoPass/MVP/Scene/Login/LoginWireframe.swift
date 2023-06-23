//
//  LoginWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol LoginWireframeProtocol: AnyObject {
    func navigate(to route: Router.Login)
}

final class LoginWireframe: BaseWireframe, LoginWireframeProtocol {
    
    static func prepare() -> LoginVC {
        let view = LoginVC(nibName: LoginVC.className, bundle: nil)
        let wireframe = LoginWireframe()
        let presenter = LoginPresenter(ui: view, wireframe: wireframe, keychainManager: KeychainManager.standard, bioAuthManager: BioAuthManager.shared)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Login) {
        switch route {
        case .home:
            showHome()
        }
    }
}

extension LoginWireframe {
    private func showHome() {
        let homeVC = HomeWireframe.prepare()
        forward(homeVC, with: .push)
    }
}
