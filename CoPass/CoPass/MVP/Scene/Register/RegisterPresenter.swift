//
//  RegisterPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol RegisterPresenterProtocol: Presenter {
    func register(with data: RegisterData)
}

final class RegisterPresenter: RegisterPresenterProtocol {
    
    private weak var ui: RegisterUI?
    private let wireframe: RegisterWireframeProtocol
    private let keychainManager: KeychainManager
    private var validate = true
    
    init(ui: RegisterUI, wireframe: RegisterWireframeProtocol, keychainManager: KeychainManager) {
        self.ui = ui
        self.wireframe = wireframe
        self.keychainManager = keychainManager
    }
    
    func register(with data: RegisterData) {
        guard checkValidData(data), let username = data.username, let password = data.password else { return }
        
        let user = User(username: username, password: password)
        let result = self.keychainManager.save(user,
                                  service: AppConstants.keychainService,
                                  account: AppConstants.keychainAccount)
        
        switch result {
        case .success(_):
            self.ui?.registerDone()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.wireframe.navigate(to: .login)
            }
        case .failure(let error):
            switch error {
            case .failureSave:
                self.ui?.showError(error: .failureRegister)
            default:
                break
            }
        }
    }
}


extension RegisterPresenter {
    private func checkValidData(_ data: RegisterData) -> Bool {
        guard let username = data.username, let password = data.password, let rePassword = data.rePassword else { return false }
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if username.isEmpty {
            self.ui?.showError(error: .emptyUsername)
            validate = false
        } else if username.rangeOfCharacter(from: characterset.inverted) != nil {
            self.ui?.showError(error: .invalidUsername)
            validate = false
        } else {
            validate = true
        }
        
        if password.isEmpty {
            self.ui?.showError(error: .emptyPassword)
            validate = false
        } else if password.count < 4 {
            self.ui?.showError(error: .invalidPassword)
            validate = false
        } else {
            validate = true
        }
        
        if rePassword.isEmpty {
            self.ui?.showError(error: .emptyRePassword)
            validate = false
        } else if password != rePassword {
            self.ui?.showError(error: .invalidRePassword)
            validate = false
        } else {
            validate = true
        }
        
        return validate
    }
}
