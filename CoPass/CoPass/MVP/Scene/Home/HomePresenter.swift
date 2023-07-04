//
//  HomePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import UIKit

protocol HomePresenterProtocol: Presenter {
    func copyPassword(record: Record)
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
    
    func copyPassword(record: Record) {
        do {
            let decryptedPassword = try record.password.aesDecrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
            UIPasteboard.general.string = decryptedPassword
            self.ui?.showAlert(title: nil, message: "password_copied".localized, error: false)
        } catch {
            self.ui?.showAlert(title: nil, message: CoError.unknownError.description, error: true)
        }
    }
}


extension HomePresenter {
    enum SectionType {
        case user(data: User), safetyScore(score: Double, count: Int, type: CoSafetyType), categories(data: [CoCategory : Int], title: String), recentlyAdded(rows: [RowType], title: String)
    }
    
    enum RowType {
        case record(data: Record)
    }
}


extension HomePresenter {
    private func prepareUI() {
        self.sections.removeAll()
        
        if let user {
            sections.append(SectionType.user(data: user))
        }
        
        let score: Double = calculateSafetyScore()
        sections.append(SectionType.safetyScore(score: score, count: self.records.count, type: CoSafetyType.getScoreType(score)))
        
       
        sections.append(SectionType.categories(data: setCategories(), title: Strings.categoryTitle))
        sections.append(.recentlyAdded(rows: getRecentlyAddedRecords(), title: Strings.recentlyAddedTitle))
        
        self.ui?.load(with: self.sections)
    }
    
    private func calculateSafetyScore() -> Double {
        let strongPasswordPoint: Double = 5.0
        let duplicatePasswordPoint: Double = 5.0
        
        var startScore: Double = 0.0
        
        let crossReference = Dictionary(grouping: self.records, by: \.password)
        let duplicatedPasswords = crossReference.filter { $1.count > 1 }
        
        self.records.forEach { record in
            do {
                let password = try record.password.aesDecrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
                if password.count > 4 {
                    startScore += strongPasswordPoint
                    if startScore > 100.0 {
                        startScore = 100.0
                    }
                } else {
                    if startScore == 0.0 { return }
                    startScore -= strongPasswordPoint
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if startScore > 0.0 {
            startScore -= Double(Int(duplicatePasswordPoint) * duplicatedPasswords.count)
        }
        
        let score = startScore / 100
        return score
    }
    
    private func setCategories() -> [CoCategory : Int] {
        var categories: [CoCategory : Int] = [:]
        
        self.records.forEach { record in
            let category = record.category
            guard let coCategory = CoCategory(rawValue: category) else { return }
            categories[coCategory] = self.records.filter({ $0.category == category }).count
        }
        
        return categories
    }
    
    private func getRecentlyAddedRecords() -> [RowType] {
        guard self.records.count > 0 else { return [] }
        
        let limit = 0..<AppConstants.recentlyAddedRecordsCount
        var recentlyAddedRecords = [RowType]()
        
        self.records[limit].forEach { record in
            let row = RowType.record(data: record)
            recentlyAddedRecords.append(row)
        }
        
        return recentlyAddedRecords
    }
}


extension HomePresenter {
    struct Strings {
        static let categoryTitle = "home_category_title".localized
        static let recentlyAddedTitle = "home_recently_added_title".localized
    }
}
