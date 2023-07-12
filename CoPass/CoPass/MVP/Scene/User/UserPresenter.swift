//
//  UserPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import Foundation

protocol UserPresenterProtocol: Presenter {
    func save(username: String, password: String, rePassword: String)
    func saveUserPhoto(image: Data)
    func deleteUser()
}

final class UserPresenter: UserPresenterProtocol {
    
    private weak var ui: UserUI?
    private let wireframe: UserWireframeProtocol
    private let storage: CoStorageProtocol
    
    private var user: User?
    private var password: String = ""
    private var validate = true
    
    init(ui: UserUI, wireframe: UserWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewDidLoad() {
        load()
    }
    
    func save(username: String, password: String, rePassword: String) {
        guard checkValidData(username: username, password: password, rePassword: rePassword), let user = self.user else { return }
        
        user.username = username
        self.storage.setMasterPassword(password: password)
        let result = storage.updateUser(with: user)
        
        switch result {
        case .success(_):
            self.ui?.saveDone()
        case .failure(let error):
            self.ui?.showError(error: error)
        }
    }
    
    func saveUserPhoto(image: Data) {
        guard let user = self.user else { return }
        user.image = image
    }
    
    func deleteUser() {
        let result = storage.deleteUser()
        switch result {
        case .success(_):
            wireframe.navigate(to: .goToOnboarding)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
}


extension UserPresenter {
    private func fetchUser() async throws -> User {
        let result = storage.fetchUser()
        switch result {
        case .success(let records): return records
        case .failure(let error): throw error
        }
    }
    
    private func load() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                user = try await fetchUser()
                password = storage.getMasterPassword() ?? ""
                prepareUI()
            } catch {
                ui?.showAlert(title: nil, message: (error as! CoError).description, error: true)
            }
        }
    }
    
    private func prepareUI() {
        guard let user = self.user else { return }
        self.ui?.load(user: user, password: self.password)
    }
}


extension UserPresenter {
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
