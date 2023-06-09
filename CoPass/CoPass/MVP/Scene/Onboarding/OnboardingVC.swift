//
//  OnboardingVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit
import ViewAnimator

final class OnboardingVC: BaseViewController, OnboardingUI {
    
    var presenter: OnboardingPresenterProtocol!
    
    @IBOutlet weak var getStartedButton: CoButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var onboardingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        self.title = Strings.pageTitle
        
        titleLabel.text = Strings.title
        subtitleLabel.text = Strings.subtitle
        
        getStartedButton.setTitle(Strings.getStartedBtnTitle, for: .normal)
        getStartedButton.type = .primary
        haveAccountLabel.text = Strings.haveAccount
        loginButton.setTitle(Strings.loginTitle, for: .normal)
        
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        UIView.animate(views: [onboardingImageView], animations: [zoomAnimation], duration: 0.3)
        
        let fromAnimation = AnimationType.vector(CGVector(dx: 0, dy: 50))
        UIView.animate(views: [titleLabel, subtitleLabel, getStartedButton], animations: [fromAnimation], delay: 0.3, duration: 0.25)
    }
    
    @IBAction func goToRegister(_ sender: Any) {
        presenter.goToPresenter()
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        presenter.goToLogin()
    }
}


extension OnboardingVC {
    struct Strings {
        static let pageTitle = "onboarding_page_title".localized
        static let title = "onboarding_title".localized
        static let subtitle = "onboarding_subtitle".localized
        static let getStartedBtnTitle = "onboarding_get_started".localized
        static let haveAccount = "onboarding_have_account".localized
        static let loginTitle = "onboarding_login".localized
    }
}
