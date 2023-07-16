//
//  ExportImportPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 16.07.2023.
//

import Foundation

protocol ExportImportPresenterProtocol: Presenter {
    func exportRecords()
}

final class ExportImportPresenter: ExportImportPresenterProtocol {
    
    private weak var ui: ExportImportUI?
    private let wireframe: ExportImportWireframeProtocol
    private let storage: CoStorageProtocol
    
    init(ui: ExportImportUI, wireframe: ExportImportWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewDidLoad() {
        
    }
}


extension ExportImportPresenter {
    func exportRecords() {
        let exportFileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        wireframe.navigate(to: .export(path: exportFileURL, completion: { [weak self] completed in
            guard let self = self, completed else {
                self?.ui?.showAlert(title: nil, message: Strings.exportFailed, error: true)
                return
            }
            let result = self.storage.saveAndExport(url: exportFileURL)
            switch result {
            case .success:
                self.ui?.showAlert(title: nil, message: Strings.exportSuccess, error: false)
                self.wireframe.navigate(to: .dismiss)
            case .failure(let error):
                self.ui?.showAlert(title: nil, message: error.description, error: true)
            }
        }))
    }
    
    func importRecords() {
        let result = storage.loadRecords(file: "\(AppConstants.appName).csv", seperator: "\n")
        switch result {
        case .success:
            self.ui?.showAlert(title: nil, message: Strings.importSuccess, error: false)
            self.wireframe.navigate(to: .dismiss)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
}


extension ExportImportPresenter {
    struct Strings {
        static let exportSuccess = "export_success".localized
        static let exportFailed = "error_export_records".localized
        static let importSuccess = "import_success".localized
    }
}
