//
//  RecordPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol RecordPresenterProtocol: Presenter {
    
}

final class RecordPresenter: RecordPresenterProtocol {
    
    private weak var ui: RecordUI?
    private let wireframe: RecordWireframeProtocol
    
    init(ui: RecordUI, wireframe: RecordWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
}
