//
//  UserWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import UIKit

protocol UserWireframeProtocol: AnyObject {
    func navigate(to route: Router.User)
}

final class UserWireframe: BaseWireframe, UserWireframeProtocol {
    
    static func prepare() -> UserVC {
        let view = UserVC(nibName: UserVC.className, bundle: nil)
        let wireframe = UserWireframe()
        let presenter = UserPresenter(ui: view, wireframe: wireframe, storage: CoStorage.shared)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.User) {
        switch route {
        case .goToOnboarding:
            goToOnboarding()
        }
    }
}

extension UserWireframe {
    private func goToOnboarding() {
        guard let window = AppDesign.Window else { return }
        let onboardingVC = OnboardingWireframe.prepare()
        AppWireframe.shared.setRootVC(vc: onboardingVC, window)
    }
}
