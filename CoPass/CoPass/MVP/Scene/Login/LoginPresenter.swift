//
//  LoginPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol LoginPresenterProtocol: Presenter {
    func fetchUser()
    func authenticateWithFaceID()
    func authenticate(with password: String)
}

final class LoginPresenter: LoginPresenterProtocol {
    
    private weak var ui: LoginUI?
    private let wireframe: LoginWireframeProtocol
    private var storage: CoStorageProtocol
    
    init(ui: LoginUI, wireframe: LoginWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewDidLoad() {
        fetchUser()
    }
    
    func fetchUser() {
        let result = storage.fetchUser()
        
        switch result {
        case .success(let user):
            self.ui?.load(username: user.username, hasBioAuth: storage.hasFaceID)
        case .failure(_):
            self.ui?.showAlert(title: nil, message: "login_failure_message".localized, error: true)
        }
    }
    
    func authenticateWithFaceID() {
        storage.authenticateWithFaceID { success in
            if success {
                DispatchQueue.main.async { [weak self] in
                    self?.wireframe.navigate(to: .tabBar)
                }
            }
        }
    }
    
    func authenticate(with password: String) {
        if let masterPassword = storage.masterPassword, masterPassword == password {
            self.wireframe.navigate(to: .tabBar)
        } else {
            self.ui?.authenticationFail()
        }
    }
}
