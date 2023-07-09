//
//  StorePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol StorePresenterProtocol: Presenter {
    func goToRecord(id: NSManagedObjectID)
    func copyPassword(record: Record)
    func deleteRecord(id: NSManagedObjectID)
    func searchRecord(with searchText: String)
}

final class StorePresenter: StorePresenterProtocol {
    
    private weak var ui: StoreUI?
    private let wireframe: StoreWireframeProtocol
    private let category: CoCategory?
    private let storage: CoStorageProtocol
    private var records: [Record] = []
    private var sections = [SectionType]()
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var searchText: String = ""
    
    init(ui: StoreUI, wireframe: StoreWireframeProtocol, category: CoCategory?, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.category = category
        self.storage = storage
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(recordsUpdated), name: Notification.Name(AppConstants.RECORDS_UPDATED), object: nil)
    }
    
    func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewWillAppear() {
        load()
    }
    
    @objc func recordsUpdated() {
        load()
    }
    
    func goToRecord(id: NSManagedObjectID) {
        wireframe.navigate(to: .openRecordWith(id: id))
    }
    
    func copyPassword(record: Record) {
        do {
            let decryptedPassword = try record.password.aesDecrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
            self.ui?.copyToPassword(password: decryptedPassword)
            storage.updateRecord(at: record.objectID, with: record)
        } catch {
            self.ui?.showAlert(title: nil, message: CoError.unknownError.description, error: true)
        }
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
    
    func searchRecord(with searchText: String) {
        self.searchText = searchText
        setWorkItem()
    }
}


extension StorePresenter {
    enum SectionType {
        case records(rows: [RowType], title: String)
    }
    
    enum RowType {
        case record(data: Record), emptyRecord
    }
}


extension StorePresenter {
    private func fetchRecords() async throws -> [Record] {
        let result = storage.fetchRecords()
        switch result {
        case .success(let records): return records
        case .failure(let error): throw error
        }
    }
    
    private func fetchRecordsWith(category: CoCategory) async throws -> [Record] {
        let result = storage.fetchRecords(with: category)
        switch result {
        case .success(let records): return records
        case .failure(let error): throw error
        }
    }
    
    private func setWorkItem() {
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem(qos: .background) { [weak self] in
            self?.fetchSearchItem()
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: requestWorkItem)
    }
    
    private func fetchSearchItem() {
        if searchText.isEmpty {
            viewWillAppear()
        } else {
            self.records = self.records.filter({(record: Record) -> Bool in
                return record.platform.range(of: searchText, options: .caseInsensitive) != nil || record.entry.range(of: searchText, options: .caseInsensitive) != nil
            })
            prepareUI()
        }
    }
    
    private func prepareUI() {
        self.sections.removeAll()
        
        if self.records.count > 0 {
            let dataDict = setRecordsWithCategory()
            
            dataDict.forEach { (category, records) in
                let rows = records.map { RowType.record(data: $0) }
                self.sections.append(SectionType.records(rows: rows, title: category.description))
            }
        } else {
            self.sections.append(SectionType.records(rows: [RowType.emptyRecord], title: ""))
        }
    
        let sortedSections = self.sections.sorted { s1, s2 in
            switch s1 {
            case .records(_, let title1):
                switch s2 {
                case .records(_, let title2):
                    return title1 < title2
                }
            }
        }
        
        self.ui?.load(with: sortedSections)
    }
    
    private func setRecordsWithCategory() -> [CoCategory : [Record]] {
        var dict: [CoCategory : [Record]] = [:]
        
        self.records.forEach { record in
            let category = record.category
            guard let coCategory = CoCategory(rawValue: category) else { return }
            dict[coCategory] = self.records.filter({ $0.category == category }).sorted(by: { $0.createdAt < $1.createdAt })
        }
        
        return dict
    }
    
    private func getRecords() -> [RowType] {
        guard self.records.count > 0 else { return [RowType.emptyRecord] }
        
        let records: [RowType] = self.records.map { RowType.record(data: $0) }
        return records
    }
    
    private func load() {
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                if let category {
                    records = try await fetchRecordsWith(category: category)
                } else {
                    records = try await fetchRecords()
                }
                prepareUI()
            } catch {
                ui?.showAlert(title: nil, message: (error as! CoError).description, error: true)
            }
            
        }
    }
}


extension StorePresenter {
    struct Strings {
        static let recordDeleted = "record_delete_successful".localized
    }
}
