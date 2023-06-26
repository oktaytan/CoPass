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
    
    init(ui: StoreUI, wireframe: StoreWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
}
