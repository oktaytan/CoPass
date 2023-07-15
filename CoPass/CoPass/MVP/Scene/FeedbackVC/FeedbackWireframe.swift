//
//  FeedbackWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 15.07.2023.
//

import UIKit

protocol FeedbackWireframeProtocol: AnyObject {
    func navigate(to route: Router.Feedback)
}

final class FeedbackWireframe: BaseWireframe, FeedbackWireframeProtocol {
    
    static func prepare() -> FeedbackVC {
        let view = FeedbackVC(nibName: FeedbackVC.className, bundle: nil)
        let wireframe = FeedbackWireframe()
        let presenter = FeedbackPresenter(ui: view, wireframe: wireframe)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.Feedback) {
        switch route {
        case .dismiss(let completion):
            backward(handler: completion, animated: true)
        }
    }
}
