//
//  ProfilePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol ProfilePresenterProtocol: Presenter {
    func handleControl(type: CoControlType)
    func editUser()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private weak var ui: ProfileUI?
    private let wireframe: ProfileWireframeProtocol
    private let storage: CoStorageProtocol
    
    private var user: User?
    private var sections = [SectionType]()
    
    init(ui: ProfileUI, wireframe: ProfileWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewWillAppear() {
        load()
    }
    
    func handleControl(type: CoControlType) {
        switch type {
        case .settings:
            wireframe.navigate(to: .goToSettings)
        case .sync:
            wireframe.navigate(to: .goToSync)
        case .notifications:
            wireframe.navigate(to: .goToNotifications)
        case .share:
            wireframe.navigate(to: .openShare)
        case .exportImport:
            wireframe.navigate(to: .exportImport)
        case .feedback:
            wireframe.navigate(to: .openSendFeedback)
        case .help:
            wireframe.navigate(to: .goToHelp)
        case .logout:
            logout()
        }
    }
    
    func editUser() {
        wireframe.navigate(to: .goToUser)
    }
}


extension ProfilePresenter {
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
                prepareUI()
            } catch {
                ui?.showAlert(title: nil, message: (error as! CoError).description, error: true)
            }
        }
    }
    
    private func prepareUI() {
        self.sections.removeAll()
        
        if let user = self.user {
            sections.append(SectionType.user(data: user))
        }
        
        var controlRows = [RowType]()
        CoControlType.allCases.forEach { controlRows.append(RowType.control(type: $0)) }
        sections.append(SectionType.controls(rows: controlRows))
        
        let dateFormatter = DateFormatter(format: "YYYY")
        let date = Date.now.toString(dateFormatter: dateFormatter)
        sections.append(SectionType.brand(name: AppConstants.appName, date: date))
        
        self.ui?.load(with: self.sections)
    }
    
    private func logout() {
        guard let user = self.user else { return }
        user.isLogin = false
        let result = storage.updateUser(with: user)
        switch result {
        case .success:
            wireframe.navigate(to: .goToLogin)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
}


extension ProfilePresenter {
    enum SectionType {
        case user(data: User), controls(rows: [RowType]), brand(name: String, date: String?)
    }
    
    enum RowType {
        case control(type: CoControlType)
    }
}


extension ProfilePresenter {
    struct Strings {
        static let exportSuccess = "export_success".localized
        static let importSuccess = "import_success".localized
    }
}
