//
//  RegisterPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

struct UserRegisterData {
    let username: String?
    let password: String?
    let rePassword: String?
}

protocol RegisterPresenterProtocol: Presenter {
    func register(_ userData: UserRegisterData)
}

final class RegisterPresenter: RegisterPresenterProtocol {
    
    private weak var ui: RegisterUI?
    private let wireframe: RegisterWireframeProtocol
    private var validate = true
    
    init(ui: RegisterUI, wireframe: RegisterWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func register(_ userData: UserRegisterData) {
        guard checkValidData(userData) else { return }
        wireframe.navigate(to: .login)
    }
}


extension RegisterPresenter {
    private func checkValidData(_ userData: UserRegisterData) -> Bool {
        guard let username = userData.username, let password = userData.password, let rePassword = userData.rePassword else { return false }
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if username.isEmpty {
            self.ui?.registerError(error: .emptyUsername)
            validate = false
        } else if username.rangeOfCharacter(from: characterset.inverted) != nil {
            self.ui?.registerError(error: .invalidUsername)
            validate = false
        } else {
            validate = true
        }
        
        if password.isEmpty {
            self.ui?.registerError(error: .emptyPassword)
            validate = false
        } else if password.count < 6 {
            self.ui?.registerError(error: .invalidPassword)
            validate = false
        } else {
            validate = true
        }
        
        if rePassword.isEmpty {
            self.ui?.registerError(error: .emptyRePassword)
            validate = false
        } else if password != rePassword {
            self.ui?.registerError(error: .invalidRePassword)
            validate = false
        } else {
            validate = true
        }
        
        return validate
    }
}
