//
//  HomePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation
import CoreData

protocol HomePresenterProtocol: Presenter {
    func goToStoreWith(category: CoCategory)
    func goToRecord(id: NSManagedObjectID)
    func copyPassword(record: Record)
    func deleteRecord(id: NSManagedObjectID)
}

final class HomePresenter: HomePresenterProtocol {
    
    private weak var ui: HomeUI?
    private let wireframe: HomeWireframeProtocol
    private let storage: CoStorageProtocol
    
    private var sections = [SectionType]()
    private var user: User?
    private var records: [Record] = []
    
    init(ui: HomeUI, wireframe: HomeWireframeProtocol, storage: CoStorageProtocol) {
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
    
    private func fetchUser() async throws -> User? {
        let result = storage.fetchUser()
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
    
    private func fetchRecords() async throws -> [Record] {
        let result = storage.fetchRecords()
        switch result {
        case .success(let records): return records
        case .failure(let error): throw error
        }
    }
    
    func goToStoreWith(category: CoCategory) {
        wireframe.navigate(to: .goToStoreWith(category: category))
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
    
    @objc func recordsUpdated() {
        load()
    }
}


extension HomePresenter {
    enum SectionType {
        case user(data: User),
             safetyScore(score: Float, count: Int, type: CoSafetyType),
             categories(data: [CoCategory : Int], title: String),
             frequentlyUsed(rows: [RowType], title: String)
    }
    
    enum RowType {
        case record(data: Record), emptyRecord
    }
}


extension HomePresenter {
    private func load(){
        Task(priority: .background) { [weak self] in
            guard let self else { return }
            do {
                user = try await fetchUser()
                records = try await fetchRecords()
                prepareUI()
            } catch {
                ui?.showAlert(title: nil, message: (error as! CoError).description, error: true)
            }
        }
    }
    
    private func prepareUI()  {
        self.sections.removeAll()
        
        if let user {
            sections.append(SectionType.user(data: user))
        }
        
        let score: Float = self.records.score
        sections.append(SectionType.safetyScore(score: score, count: self.records.count, type: CoSafetyType.getScoreType(score)))
        
       
        sections.append(SectionType.categories(data: self.records.getCategories(), title: Strings.categoryTitle))
        sections.append(.frequentlyUsed(rows: getFrequentlyUsedRecords(), title: Strings.frequentlyUsedTitle))
        
        self.ui?.load(with: self.sections)
    }
    
    private func getFrequentlyUsedRecords() -> [RowType] {
        guard self.records.count > 0 else { return [RowType.emptyRecord] }
        
        guard self.records.contains(where: { $0.usageCount >= 5 }) else {
            if self.records.count > AppConstants.recordsShowingCount {
                return self.records[0..<AppConstants.recordsShowingCount].map { RowType.record(data: $0) }
            } else {
                return self.records.map { RowType.record(data: $0) }
            }
        }
        
        let frequentlyUsedRecords: [RowType] = self.records.filter { $0.usageCount >= 5 }.map { RowType.record(data: $0) }
        return frequentlyUsedRecords
    }
}


extension HomePresenter {
    struct Strings {
        static let categoryTitle = "home_category_title".localized
        static let frequentlyUsedTitle = "home_frequently_used_title".localized
        static let recordDeleted = "record_delete_successful".localized
    }
}
