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
    
    func deleteUser() {
        KeychainManager.standard.delete(service: AppConstants.keychainService, account: AppConstants.keychainAccount)
    }
    
    func hideNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
}


extension BaseViewController: BaseUI {
    func showAlert(title: String?, message: String?, error: Bool) {
        DispatchQueue.main.async {
            SPIndicator.present(title: title ?? "", message: message, preset: error ? .error : .done)
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
