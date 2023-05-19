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
    
    static func prepare() -> OnboardingController {
        let view = OnboardingController(nibName: OnboardingController.className, bundle: nil)
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
            showRegister()
        }
    }
    
}

extension OnboardingWireframe {
    func showRegister() {
        
    }
    
    func showLogin() {
        
    }
}
