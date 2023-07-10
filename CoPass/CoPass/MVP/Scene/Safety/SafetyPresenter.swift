//
//  SafetyPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol SafetyPresenterProtocol: Presenter {
    func goToRecord(id: NSManagedObjectID)
    func copyPassword(record: Record)
    func deleteRecord(id: NSManagedObjectID)
    func changeGroup(group: CoScoreGroup)
}

final class SafetyPresenter: SafetyPresenterProtocol {
    
    private weak var ui: SafetyUI?
    private let wireframe: SafetyWireframeProtocol
    private let storage: CoStorageProtocol
    
    private var sections: [SectionType] = []
    private var records: [Record] = []
    private var selectedGroup: CoScoreGroup = .strong
    
    init(ui: SafetyUI, wireframe: SafetyWireframeProtocol, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.storage = storage
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(recordsUpdated), name: Notification.Name(AppConstants.RECORDS_UPDATED), object: nil)
    }
    
    func viewWillAppear() {
        load()
    }
    
    func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func recordsUpdated() {
        load()
    }
    
    func goToRecord(id: NSManagedObjectID) {
        wireframe.navigate(to: .openRecordWith(id: id))
    }
    
    func copyPassword(record: Record) {
        self.ui?.copyToPassword(password: record.decryptedPassword)
        storage.updateRecord(at: record.objectID, with: record)
    }
    
    func deleteRecord(id: NSManagedObjectID) {
        let result = storage.deleteRecord(with: id)
        switch result {
        case .success(_):
            self.records = self.records.filter { $0.objectID != id }
            self.prepareUI()
            self.ui?.showAlert(title: nil, message: Strings.recordDeleted, error: false)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
    
    func changeGroup(group: CoScoreGroup) {
        self.selectedGroup = group
        prepareUI()
    }
}


extension SafetyPresenter {
    private func fetchRecords() async throws -> [Record] {
        let result = storage.fetchRecords()
        switch result {
        case .success(let records): return records
        case .failure(let error): throw error
        }
    }
    
    private func load() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                records = try await fetchRecords()
                prepareUI()
            } catch {
                ui?.showAlert(title: nil, message: (error as! CoError).description, error: true)
            }
            
        }
    }
    
    private func prepareUI() {
        self.sections.removeAll()
        
        let scoreEntity = SafetyScoreEntity(data: self.records)
        self.sections.append(SectionType.board(entity: scoreEntity))
        
        if self.records.count > 0, let selectedRecords = scoreEntity.groups[self.selectedGroup], selectedRecords.count > 0 {
            let rows: [RowType] = selectedRecords.map { RowType.record(data: $0) }
            self.sections.append(SectionType.records(rows: rows, title: selectedGroup.description))
        } else {
            self.sections.append(SectionType.records(rows: [RowType.emptyRecord], title: ""))
        }
        
        self.ui?.load(with: self.sections)
    }
}


extension SafetyPresenter {
    enum SectionType {
        case board(entity: SafetyScoreEntity), records(rows: [RowType], title: String)
    }
    
    enum RowType {
        case record(data: Record), emptyRecord
    }
}


extension SafetyPresenter {
    struct Strings {
        static let recordDeleted = "record_delete_successful".localized
    }
}
