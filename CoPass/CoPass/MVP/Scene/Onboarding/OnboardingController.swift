//
//  OnboardingController.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit

final class OnboardingController: BaseViewController, OnboardingUI {
    
    var presenter: OnboardingPresenterProtocol!
    
    @IBOutlet weak var getStartedButton: CoButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        getStartedButton.type = .primary
    }
    
    func load() {
        
    }
    
}
