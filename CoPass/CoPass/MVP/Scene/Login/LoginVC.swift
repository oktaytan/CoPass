//
//  LoginVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import UIKit
import LocalAuthentication

final class LoginVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var faceIDView: UIView!
    @IBOutlet weak var faceIDLabel: UILabel!
    @IBOutlet weak var orTextLabel: UILabel!
    @IBOutlet weak var masterPasswordField: OneTimeCodeTextField!
    @IBOutlet weak var masterPasswordLabel: UILabel!
    @IBOutlet weak var loginBtn: CoButton!
    
    var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        hideNavBar()
        
        subtitleLabel.text = Strings.subtitle
        faceIDLabel.text = Strings.faceID
        orTextLabel.text = Strings.or
        masterPasswordLabel.text = Strings.masterPassword
        
        faceIDView.cornerRadius = AppConstants.appUIRadius
        
        loginBtn.type = .primary
        loginBtn.setTitle(Strings.loginAction, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        setupKeyboardNotifcationListeners(scrollView)
        
        masterPasswordField.configure(withSlotCount: 4, andSpacing: 18)
        masterPasswordField.didReceiveCode = { [weak self] code in
            self?.presenter.authenticate(with: code)
        }
    }
    
    @IBAction func faceIDBtnTapped(_ sender: Any) {
        presenter.authenticateWithFaceID()
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let masterPassword = masterPasswordField.text, !masterPassword.isEmpty else {
            showAlert(title: nil, message: Strings.Errors.fillPassword, error: true)
            return
        }
        presenter.authenticate(with: masterPassword)
    }
}


extension LoginVC: LoginUI {
    func load(username: String, hasBioAuth: Bool) {
        titleLabel.text = String(format: Strings.title, username.capitalized)
        
        faceIDView.isHidden = !hasBioAuth
        orTextLabel.isHidden = !hasBioAuth
    }
    
    func authenticationFail() {
        showAlert(title: Strings.Errors.loginFailureTitle, message: Strings.Errors.loginFailureMessage, error: true)
        masterPasswordField.clear()
    }
}


extension LoginVC {
    struct Strings {
        static let title = "login_title %@".localized
        static let subtitle = "login_subtitle".localized
        static let faceID = "login_faceID".localized
        static let or = "login_or_text".localized
        static let masterPassword = "login_master_password".localized
        static let loginAction = "login_action".localized
        
        struct Errors {
            static let emptyField = "register_empty_field".localized
            static let fillPassword = "login_fill_password".localized
            static let loginFailureTitle = "login_failure_title".localized
            static let loginFailureMessage = "login_failure_message".localized
        }
    }
}
