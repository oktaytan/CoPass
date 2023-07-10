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
    
    lazy var loadingView: UIView = {
        let loaderView = UIView(frame: self.view.bounds)
        loaderView.backgroundColor = .white.withAlphaComponent(0.95)
        let size: CGFloat = 44.0
        let xSnap = (loaderView.frame.size.width / 2) - (size / 2)
        let ySnap = (loaderView.frame.size.height / 2) - (size / 2)
        let indicatorView = NVActivityIndicatorView(frame: CGRect(x: xSnap, y: ySnap, width: size, height: size),
                                           type: .ballTrianglePath,
                                           color: .coPurple,
                                           padding: nil)
        indicatorView.startAnimating()
        loaderView.addSubview(indicatorView)
        return loaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // Override
    }
    
    func deleteUser() {
        CoStorage.shared.deleteUser()
    }
    
    func showNavBar() {
        self.navigationController?.isNavigationBarHidden = false
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
    
    func showLoading() {
        self.view.addSubview(loadingView)
    }
    
    func hideLoading() {
        loadingView.removeFromSuperview()
    }
    
    func deleteRecordDialog(completion: @escaping (Bool) -> ()) {
        let deletedAction = UIAlertAction(title: Strings.dialogDelete, style: .destructive) { _ in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: Strings.dialogCancel, style: .cancel) { _ in
            completion(false)
        }
        showDialog(message: Strings.recordDeleteConfirm, actions: [deletedAction, cancelAction])
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
        static let recordDeleteConfirm = "record_delete_confirm".localized
        static let copyPassword = "password_copied".localized
    }
}
