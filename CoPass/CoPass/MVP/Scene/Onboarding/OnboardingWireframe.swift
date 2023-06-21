//
//  OnboardingWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import Foundation

protocol OnboardingWireframeProtocol: AnyObject {
    func navigate(to route: Router.Onboarding)
}

final class OnboardingWireframe: BaseWireframe, OnboardingWireframeProtocol {
    
    static func prepare() -> OnboardingVC {
        let view = OnboardingVC(nibName: OnboardingVC.className, bundle: nil)
        let wireframe = OnboardingWireframe()
        let presenter = OnboardingPresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Onboarding) {
        switch route {
        case .register:
            showRegister()
        case .login:
            showLogin()
        }
    }
}

extension OnboardingWireframe {
    private func showRegister() {
        let registerVC = RegisterWireframe.prepare()
        forward(registerVC, with: .push)
    }
    
    private func showLogin() {
        let loginVC = LoginWireframe.prepare()
        forward(loginVC, with: .push)
    }
}
