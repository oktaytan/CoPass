//
//  OnboardingPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import Foundation

protocol OnboardingPresenterProtocol: Presenter {
    func start()
}

final class OnboardingPresenter: OnboardingPresenterProtocol {
    
    private weak var ui: OnboardingUI?
    private let wireframe: OnboardingWireframeProtocol
    
    init(ui: OnboardingUI, wireframe: OnboardingWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        self.ui?.load()
    }
    
    func start() {
        
    }
}
