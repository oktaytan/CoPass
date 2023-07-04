//
//  StorePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol StorePresenterProtocol: Presenter {
    
}

final class StorePresenter: StorePresenterProtocol {
    
    private weak var ui: StoreUI?
    private let wireframe: StoreWireframeProtocol
    private let category: CoCategory?
    private let storage: CoStorageProtocol
    private var records: [Record] = []
    
    init(ui: StoreUI, wireframe: StoreWireframeProtocol, category: CoCategory?, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.category = category
        self.storage = storage
    }
    
    func viewDidLoad() {
        if let category {
            fetchRecordsWith(category: category)
        } else {
            
        }
    }
    
    private func fetchRecordsWith(category: CoCategory) {
        let result = storage.fetchRecords(with: category)
        switch result {
        case .success(let records):
            print(records)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
}
