//
//  HomePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation

protocol HomePresenterProtocol: Presenter {
    
}

final class HomePresenter: HomePresenterProtocol {
    
    private weak var ui: HomeUI?
    private let wireframe: HomeWireframeProtocol
    
    init(ui: HomeUI, wireframe: HomeWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
}
