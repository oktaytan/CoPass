//
//  LoginVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import UIKit

final class LoginVC: BaseViewController, LoginUI {
    
    var presenter: LoginPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
}
