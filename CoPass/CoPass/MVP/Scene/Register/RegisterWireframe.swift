//
//  RegisterWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol RegisterWireframeProtocol: AnyObject {
    func navigate(to route: Router.Register)
}

final class RegisterWireframe: BaseWireframe, RegisterWireframeProtocol {
    
    static func prepare() -> RegisterVC {
        let view = RegisterVC(nibName: RegisterVC.className, bundle: nil)
        let wireframe = RegisterWireframe()
        let presenter = RegisterPresenter(ui: view, wireframe: wireframe, storage: CoStorage.shared)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Register) {
        switch route {
        case .login:
            showLogin()
        }
    }
}

extension RegisterWireframe {
    private func showLogin() {
        let loginVC = LoginWireframe.prepare()
        forward(loginVC, with: .push)
    }
}
