//
//  CoTabBarPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol CoTabBarPresenterProtocol: Presenter {
    func showAddRecord()
}

final class CoTabBarPresenter: CoTabBarPresenterProtocol {
    
    private weak var ui: CoTabBarUI?
    private let wireframe: CoTabBarWireframeProtocol
    
    init(ui: CoTabBarUI, wireframe: CoTabBarWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
    func showAddRecord() {
        wireframe.navigate(to: .showAddRecord)
    }
}
