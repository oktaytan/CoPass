//
//  RegisterVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import UIKit

final class RegisterVC: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var usernameTextField: CoTextField!
    @IBOutlet weak var masterPasswordTextField: CoTextField!
    @IBOutlet weak var reMasterPasswordTextField: CoTextField!
    @IBOutlet weak var registerButton: CoButton!
    
    var presenter: RegisterPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        titleLabel.text = Strings.title
        subtitleLabel.text = Strings.subtitle
        
        usernameTextField.placeholder = Strings.username
        masterPasswordTextField.placeholder = Strings.masterPassword
        reMasterPasswordTextField.placeholder = Strings.reMasterPassword
        
        usernameTextField.delegate = self
        masterPasswordTextField.delegate = self
        reMasterPasswordTextField.delegate = self
        
        registerButton.type = .primary
        registerButton.setTitle(Strings.registerAction, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        setupKeyboardNotifcationListeners(scrollView)
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        registerAction()
    }
    
    private func registerAction() {
        let data = RegisterData(username: usernameTextField.text,
                                        password: masterPasswordTextField.text,
                                        rePassword: reMasterPasswordTextField.text)
        presenter.register(with: data)
    }
    
    @objc private func hideKeyboard() {
        usernameTextField.resignFirstResponder()
        masterPasswordTextField.resignFirstResponder()
        reMasterPasswordTextField.resignFirstResponder()
    }
}


extension RegisterVC: RegisterUI {
    func showError(error: RegisterError) {
        switch error {
        case .emptyUsername:
            usernameTextField.errorMessage = Strings.Errors.emptyField
        case .emptyPassword:
            masterPasswordTextField.errorMessage = Strings.Errors.emptyField
        case .emptyRePassword:
            reMasterPasswordTextField.errorMessage = Strings.Errors.emptyField
        case .invalidUsername:
            usernameTextField.errorMessage = Strings.Errors.invalidUsername
        case .invalidPassword:
            masterPasswordTextField.errorMessage = Strings.Errors.invalidMasterPassword
        case .invalidRePassword:
            reMasterPasswordTextField.errorMessage = Strings.Errors.invalid_ReMasterPassword
        case .failureRegister:
            showAlert(title: nil, message: Strings.registerFailure, error: true)
        }
    }
    
    func registerDone() {
        showAlert(title: nil, message: Strings.registerSuccess, error: false)
    }
}


extension RegisterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        
        if newText != "" {
            (textField as! CoTextField).errorMessage = nil
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registerAction()
        return true
    }
}


extension RegisterVC {
    struct Strings {
        static let title = "register_title".localized
        static let subtitle = "register_subtitle".localized
        static let username = "register_username".localized
        static let masterPassword = "register_master_password".localized
        static let reMasterPassword = "register_remaster_password".localized
        static let registerAction = "register_action".localized
        static let registerSuccess = "register_success".localized
        static let registerFailure = "register_failure".localized
        
        struct Errors {
            static let emptyField = "register_empty_field".localized
            static let invalidUsername = "register_invalid_username".localized
            static let invalidMasterPassword = "register_invalid_master_password".localized
            static let invalid_ReMasterPassword = "register_invalid_remaster_password".localized
        }
    }
}
