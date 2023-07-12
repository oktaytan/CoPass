//
//  BaseViewController.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit
import SPIndicator
import SnapKit
import NVActivityIndicatorView
import CoreData

class BaseViewController: UIViewController {
    
    var showIndicator: Bool = false {
        didSet {
            showModalIndicator()
        }
    }
    
    lazy var modalIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .coBg
        view.cornerRadius = 2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Override
    }
    
    func showNavBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func hideNavBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showTabBar() {
        guard let coTabBar = self.tabBarController as? CoTabBarVC else { return }
        coTabBar.coTabBar.isHidden = true
    }
    
    func hideTabBar() {
        guard let coTabBar = self.tabBarController as? CoTabBarVC else { return }
        coTabBar.coTabBar.isHidden = false
    }
    
    func showModalIndicator() {
        if showIndicator {
            self.view.addSubview(modalIndicator)
            modalIndicator.snp.makeConstraints { make in
                make.top.equalTo(self.view).offset(10)
                make.width.equalTo(44)
                make.height.equalTo(4)
                make.centerX.equalTo(self.view)
            }
        }
    }
}


extension BaseViewController: BaseUI {
    func showAlert(title: String?, message: String?, error: Bool) {
        DispatchQueue.main.async {
            SPIndicator.present(title: title ?? "", message: message, preset: error ? .error : .done)
        }
    }
    
    func showBottomPopup(message: String?) {
        DispatchQueue.main.async {
            SPIndicator.present(title: "", message: message, preset: .done, from: .bottom)
        }
    }
    
    func showDialog(message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: AppConstants.appName, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func deleteDialog(message: String, completion: @escaping (Bool) -> ()) {
        let deletedAction = UIAlertAction(title: Strings.dialogDelete, style: .destructive) { _ in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: Strings.dialogCancel, style: .cancel) { _ in
            completion(false)
        }
        showDialog(message: message, actions: [deletedAction, cancelAction])
    }
    
    func copyPassword(password: String) {
        self.showBottomPopup(message: Strings.copyPassword)
        UIPasteboard.general.string = password
    }
}


extension BaseViewController {
    struct Strings {
        static let dialogDelete = "dialog_delete".localized
        static let dialogCancel = "dialog_cancel".localized
        static let copyPassword = "password_copied".localized
    }
}
