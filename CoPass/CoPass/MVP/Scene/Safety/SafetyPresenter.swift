//
//  SafetyPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol SafetyPresenterProtocol: Presenter {
    
}

final class SafetyPresenter: SafetyPresenterProtocol {
    
    private weak var ui: SafetyUI?
    private let wireframe: SafetyWireframeProtocol
    
    init(ui: SafetyUI, wireframe: SafetyWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
}
