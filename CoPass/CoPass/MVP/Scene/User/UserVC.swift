//
//  UserVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import UIKit
import ViewAnimator

final class UserVC: BaseViewController {
    
    typealias Presenter = UserPresenterProtocol
    
    var presenter: Presenter!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: CoCircularImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editUserTitle: UILabel!
    @IBOutlet weak var usernameTextField: CoTextField!
    @IBOutlet weak var masterPasswordTextField: CoTextField!
    @IBOutlet weak var reMasterPasswordTextField: CoTextField!
    @IBOutlet weak var saveBtn: CoButton!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        
        editUserTitle.text = Strings.title
        usernameTextField.placeholder = Strings.username
        masterPasswordTextField.placeholder = Strings.masterPassword
        reMasterPasswordTextField.placeholder = Strings.reMasterPassword
        
        usernameTextField.delegate = self
        masterPasswordTextField.delegate = self
        reMasterPasswordTextField.delegate = self
        
        saveBtn.type = .primary
        saveBtn.setTitle(Strings.saveAction, for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        
        let fromAnimation = AnimationType.from(direction: .left, offset: 100)
        UIView.animate(views: [usernameTextField,
                              masterPasswordTextField,
                               reMasterPasswordTextField], animations: [fromAnimation], duration: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar()
    }
    
    @IBAction func editUserImageTapped(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func saveUserTapped(_ sender: Any) {
        saveAction()
    }
    
    @IBAction func deleteUserTapped(_ sender: Any) {
        deleteDialog(message: Strings.deleteUserDialog) { [weak self] status in
            guard status else { return }
            self?.presenter.deleteUser()
        }
    }
    
    private func saveAction() {
        guard let username = usernameTextField.text, let password = masterPasswordTextField.text, let rePassword = reMasterPasswordTextField.text else {
            showAlert(title: nil, message: Strings.Errors.allFieldFill, error: true)
            return
        }
        presenter.save(username: username, password: password, rePassword: rePassword)
    }
}


extension UserVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        
        if newText != "" {
            (textField as! CoTextField).errorMessage = nil
        }
        
        if textField.tag == 1 {
            self.usernameLabel.text = newText
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveAction()
        return true
    }
}


extension UserVC: UserUI {
    func load(user: User, password: String) {
        DispatchQueue.main.async { [weak self] in
            self?.usernameLabel.text = user.username
            self?.usernameTextField.text = user.username
            self?.masterPasswordTextField.text = password
            self?.reMasterPasswordTextField.text = password
            
            if let imageData = user.image {
                self?.userImageView.image = UIImage(data: imageData)
            } else {
                self?.userImageView.image = UIImage(named: "avatar_placeholder")!
            }
        }
    }
    
    func showError(error: CoError) {
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
            showAlert(title: nil, message: Strings.saveFailure, error: true)
        default:
            break
        }
    }
    
    func saveDone() {
        showAlert(title: nil, message: Strings.saveSuccess, error: false)
    }
}


extension UserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            userImageView.image = UIImage(data: jpegData)
            presenter.saveUserPhoto(image: jpegData)
        }

        dismiss(animated: true)
    }
}


extension UserVC {
    struct Strings {
        static let title = "profile_user_edit_title".localized
        static let username = "register_username".localized
        static let masterPassword = "register_master_password".localized
        static let reMasterPassword = "register_remaster_password".localized
        static let saveAction = "save".localized
        static let saveSuccess = "profile_user_update_success".localized
        static let saveFailure = "profile_user_update_failure".localized
        static let deleteUserDialog = "profile_delete_user_confirm".localized
        
        struct Errors {
            static let emptyField = "register_empty_field".localized
            static let allFieldFill = "register_all_field_should_fill".localized
            static let invalidUsername = "register_invalid_username".localized
            static let invalidMasterPassword = "register_invalid_master_password".localized
            static let invalid_ReMasterPassword = "register_invalid_remaster_password".localized
        }
    }
}
