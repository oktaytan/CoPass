//
//  SafetyVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit

final class SafetyVC: BaseViewController {
    
    var presenter: SafetyPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
}


extension SafetyVC: SafetyUI {
    
}
