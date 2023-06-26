//
//  RecordVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit

final class RecordVC: BaseViewController {
    
    var presenter: RecordPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
}


extension RecordVC: RecordUI {
    
}
