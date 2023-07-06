//
//  LoginVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import UIKit
import ViewAnimator

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
        
//        CoStorage.shared.saveRecord(with: .init(platform: "Twitter", entry: "@cawisdev", password: "123456", category: .app))
//        CoStorage.shared.saveRecord(with: .init(platform: "Spotify", entry: "@zidak", password: "zidak3333", category: .app))
//        CoStorage.shared.saveRecord(with: .init(platform: "Gmail", entry: "zidak@gmail.com", password: "998H44cawis", category: .login))
//        CoStorage.shared.saveRecord(with: .init(platform: "Linkedin", entry: "/cawistan", password: "111111", category: .login))
//        CoStorage.shared.saveRecord(with: .init(platform: "Memrise", entry: "/cawistan", password: "2233445", category: .login))
//        CoStorage.shared.saveRecord(with: .init(platform: "Cawis Bank", entry: "Visa Card", password: "seeH2222", category: .bank))
//        CoStorage.shared.saveRecord(with: .init(platform: "Zidak Bank", entry: "Master Card", password: "rrr5", category: .bank))
//        CoStorage.shared.saveRecord(with: .init(platform: "Facebook", entry: "cawisdev", password: "123456", category: .login))
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
        
        masterPasswordField.configure(withSlotCount: 4, andSpacing: 18)
        masterPasswordField.didReceiveCode = { [weak self] code in
            self?.presenter.authenticate(with: code)
        }
        
        let scaleAnimation = AnimationType.zoom(scale: 0.2)
        let fromAnimation = AnimationType.from(direction: .bottom, offset: 50)
        
        UIView.animate(views: [faceIDView], animations: [scaleAnimation])
        UIView.animate(views: [masterPasswordField], animations: [fromAnimation], delay: 0.2)
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
