//
//  BaseViewController.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit
import SPIndicator

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Override
    }
    
    func bind() {
        // Overrride
    }
}


extension BaseViewController: BaseUI {
    func showAlert(title: String?, message: String?, error: Bool) {
        SPIndicator.present(title: title ?? "", message: message, preset: error ? .error : .done)
    }
}
