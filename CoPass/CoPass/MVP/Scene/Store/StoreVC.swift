//
//  StoreVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit

final class StoreVC: BaseViewController {
    
    var presenter: StorePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
}


extension StoreVC: StoreUI {
    
}
