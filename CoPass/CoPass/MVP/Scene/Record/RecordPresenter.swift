//
//  RecordPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol RecordPresenterProtocol: Presenter {
    func selectedCategory(category: CoCategory)
    func changeField(type: CoRecordFieldType)
    func saveRecord()
    func deleteRecord()
}

final class RecordPresenter: RecordPresenterProtocol {
    
    private weak var ui: RecordUI?
    private let wireframe: RecordWireframeProtocol
    private var storage: CoStorageProtocol
    
    private var id: NSManagedObjectID?
    private var status: RecordStatusType
    private var recordEntity = RecordEntity()
    private var record: Record?
    private var sections: [SectionType] = []
    
    init(ui: RecordUI, wireframe: RecordWireframeProtocol, id: NSManagedObjectID?, status: RecordStatusType, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.id = id
        self.status = status
        self.storage = storage
    }
    
    func viewDidLoad() {
        fetchRecord(id: self.id)
        prepareUI()
    }
    
    func selectedCategory(category: CoCategory) {
        recordEntity.category = category
        prepareUI()
    }
    
    func changeField(type: CoRecordFieldType) {
        switch type {
        case .platform(let text):
            self.recordEntity.platform = text
        case .entry(let text):
            self.recordEntity.entry = text
        case .password(let text):
            self.recordEntity.password = text
        default:
            break
        }
        self.checkValidData(record: self.recordEntity)
    }
    
    func saveRecord() {
        guard checkValidData(record: self.recordEntity) else { return }
        if let id = self.id, let record = self.record {
            record.category = recordEntity.category.rawValue
            record.platform = recordEntity.platform
            record.entry = recordEntity.entry
            record.password = try! recordEntity.password.aesEncrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
            let updateResult = storage.updateRecord(at: id, with: record)
            switch updateResult {
            case .success:
                self.ui?.showAlert(title: nil, message: Strings.updateSuccessful, error: false)
            case .failure(let error):
                self.ui?.showAlert(title: nil, message: error.description, error: true)
            }
        } else {
            let result = storage.saveRecord(with: self.recordEntity)
            switch result {
            case .success:
                self.recordEntity = RecordEntity()
                self.ui?.showAlert(title: nil, message: Strings.saveSuccessful, error: false)
                prepareUI()
            case .failure(let error):
                self.ui?.showAlert(title: nil, message: error.description, error: true)
            }
        }
        
        Notification.recordsUpdated()
        wireframe.navigate(to: .dismiss)
    }
    
    func deleteRecord() {
        guard let id = self.id else { return }
        let result = storage.deleteRecord(with: id)
        switch result {
        case .success:
            self.ui?.showAlert(title: nil, message: Strings.deleteSuccessful, error: false)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
        
        Notification.recordsUpdated()
        wireframe.navigate(to: .dismiss)
    }
}


extension RecordPresenter {
    private func fetchRecord(id: NSManagedObjectID?) {
        guard let id = self.id else { return }
        let result = storage.fetchRecord(with: id)
        switch result {
        case .success(let record):
            self.record = record
            self.recordEntity = RecordEntity(data: record)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
    
    private func prepareUI() {
        self.sections.removeAll()
        
        sections.append(SectionType.categories(data: CoCategory.allCases, selectedCategory: self.recordEntity.category))
        sections.append(SectionType.form(record: self.recordEntity))
        sections.append(SectionType.preview(record: self.recordEntity))
        
        self.ui?.load(data: self.sections, with: self.status)
        self.checkValidData(record: self.recordEntity)
    }
}


extension RecordPresenter {
    enum SectionType {
        case categories(data: [CoCategory], selectedCategory: CoCategory),
             form(record: RecordEntity),
             preview(record: RecordEntity)
    }
}


extension RecordPresenter {
    @discardableResult
    private func checkValidData(record: RecordEntity) -> Bool {
        guard record.platform.isEmpty || record.entry.isEmpty || record.password.isEmpty else {
            self.ui?.validation(status: true)
            return true
        }
        self.ui?.validation(status: false)
        return false
    }
}


extension RecordPresenter {
    struct Strings {
        static let saveSuccessful = "record_save_successful".localized
        static let updateSuccessful = "record_update_successful".localized
        static let deleteSuccessful = "record_delete_successful".localized
        struct Errors {
            static let emptyField = "error_empty_field".localized
        }
    }
}
