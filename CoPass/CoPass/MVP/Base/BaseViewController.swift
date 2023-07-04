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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func showLoading() {
        self.view.addSubview(loadingView)
    }
    
    func hideLoading() {
        loadingView.removeFromSuperview()
    }
}
