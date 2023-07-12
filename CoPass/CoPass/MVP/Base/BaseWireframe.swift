//
//  BaseWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit

class BaseWireframe {
    
    weak var view: UIViewController!
    
    func forward(_ vc: UIViewController, with type: TransitionType, animated: Bool = true) {
        switch type {
        case .push:
            guard let navController = view.navigationController else { return }
            navController.pushViewController(vc, animated: animated)
        case .present(let from):
            vc.modalPresentationStyle = .fullScreen
            from.present(vc, animated: animated)
        case .modal(let from):
            vc.modalPresentationStyle = .automatic
            from.present(vc, animated: animated)
        case .pageSheet(let from, let detent):
            vc.modalPresentationStyle = .pageSheet
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.selectedDetentIdentifier = detent
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            from.present(vc, animated: animated)
        case .root(let window):
            window.rootViewController = vc
        }
    }
    
    func backward(handler: (() -> Void)? = nil, animated: Bool) {
        view.dismiss(animated: animated, completion: handler)
    }
}
