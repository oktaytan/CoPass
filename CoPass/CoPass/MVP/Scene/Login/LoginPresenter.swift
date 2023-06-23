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
    private var keychainManager: KeychainManager
    private var bioAuthManager: BioAuthManager
    
    init(ui: LoginUI, wireframe: LoginWireframeProtocol, keychainManager: KeychainManager, bioAuthManager: BioAuthManager) {
        self.ui = ui
        self.wireframe = wireframe
        self.keychainManager = keychainManager
        self.bioAuthManager = bioAuthManager
    }
    
    func viewDidLoad() {
        fetchUser()
    }
    
    func fetchUser() {
        guard let user = keychainManager.read(service: AppConstants.keychainService,
                                              account: AppConstants.keychainAccount,
                                              type: User.self) else { return }
        
        let hasBioAuth = bioAuthManager.biometricType == .faceID
        self.ui?.load(username: user.username, hasBioAuth: hasBioAuth)
    }
    
    func authenticateWithFaceID() {
        bioAuthManager.authenticate { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async { [weak self] in
                    self?.wireframe.navigate(to: .home)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func authenticate(with password: String) {
        if let user = keychainManager.read(service: AppConstants.keychainService, account: AppConstants.keychainAccount, type: User.self), user.password == password {
            self.wireframe.navigate(to: .home)
        } else {
            self.ui?.authenticationFail()
        }
    }
}
