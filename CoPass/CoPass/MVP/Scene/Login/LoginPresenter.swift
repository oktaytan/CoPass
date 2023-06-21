//
//  LoginPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol LoginPresenterProtocol: Presenter {
    
}

final class LoginPresenter: LoginPresenterProtocol {
    
    private weak var ui: LoginUI?
    private let wireframe: LoginWireframeProtocol
    
    init(ui: LoginUI, wireframe: LoginWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
}
