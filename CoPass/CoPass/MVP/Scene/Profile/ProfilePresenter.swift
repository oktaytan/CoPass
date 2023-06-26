//
//  ProfilePresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol ProfilePresenterProtocol: Presenter {
    
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private weak var ui: ProfileUI?
    private let wireframe: ProfileWireframeProtocol
    
    init(ui: ProfileUI, wireframe: ProfileWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
}
