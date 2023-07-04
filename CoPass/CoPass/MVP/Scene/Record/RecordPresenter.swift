//
//  RecordPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation
import CoreData

protocol RecordPresenterProtocol: Presenter {
    
}

final class RecordPresenter: RecordPresenterProtocol {
    
    private weak var ui: RecordUI?
    private let wireframe: RecordWireframeProtocol
    private var id: NSManagedObjectID?
    private var record: Record?
    private var storage: CoStorageProtocol
    
    init(ui: RecordUI, wireframe: RecordWireframeProtocol, id: NSManagedObjectID?, storage: CoStorageProtocol) {
        self.ui = ui
        self.wireframe = wireframe
        self.id = id
        self.storage = storage
    }
    
    func viewDidLoad() {
        guard let id = self.id else { return }
        fetchRecord(id: id)
    }
    
    private func fetchRecord(id: NSManagedObjectID) {
        let result = storage.fetchRecord(with: id)
        switch result {
        case .success(let record):
            print(record.category)
        case .failure(let error):
            self.ui?.showAlert(title: nil, message: error.description, error: true)
        }
    }
}
