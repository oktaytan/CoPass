//
//  RegisterPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol RegisterPresenterProtocol: Presenter {
    func register(username: String, password: String, rePassword: String)
}

final class RegisterPresenter: RegisterPresenterProtocol {
    
    private weak var ui: RegisterUI?
    private let wireframe: RegisterWireframeProtocol
    private let storage: CoStorageProtocol
    private var validate = true
    
    init(ui: RegisterUI, wireframe: RegisterWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func register(username: String, password: String, rePassword: String) {
        guard checkValidData(username: username, password: password, rePassword: rePassword) else { return }
        
        let data = RegisterData(username: username, password: password)
        let result = storage.register(with: data)
        
        switch result {
        case .success(_):
            self.ui?.registerDone()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.wireframe.navigate(to: .login)
            }
        case .failure(let error):
            self.ui?.showError(error: error)
        }
    }
}


extension RegisterPresenter {
    private func checkValidData(username: String, password: String, rePassword: String) -> Bool {
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
