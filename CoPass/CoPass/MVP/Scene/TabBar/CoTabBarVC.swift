//
//  CoTabBarVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 25.06.2023.
//

import UIKit
import SPIndicator

final class CoTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    lazy var coTabBar: CoTabBar = {
        let tabBar: CoTabBar = CoTabBar()
        return tabBar
    }()
    
    var presenter: CoTabBarPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        
        coTabBar.delegate = self
        coTabBar.selectedIndex = 0
        self.view.addSubview(coTabBar)
        coTabBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(106)
        }
    }
}


extension CoTabBarVC: CoTabBarDelegate {
    func tapped(_ tag: Int) {
        selectedIndex = tag
    }
    
    func addRecordTapped() {
        presenter.showAddRecord()
    }
}


extension CoTabBarVC: CoTabBarUI {
    func showAlert(title: String?, message: String?, error: Bool) {
        DispatchQueue.main.async {
            SPIndicator.present(title: title ?? "", message: message, preset: error ? .error : .done)
        }
    }
}
