//
//  ProfileVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit

final class ProfileVC: BaseViewController {
    
    typealias Presenter = ProfilePresenterProtocol
    typealias Provider = ProfileTableViewProvider
    
    var presenter: Presenter!
    var provider: Provider!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservationListener()
        setupListView()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        hideNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavBar()
    }
    
    func inject(presenter: Presenter, provider: Provider) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func addObservationListener() {
        provider.stateClosure = { [weak self] event in
            switch event {
            case .updateUI(let data):
                self?.tableViewUserActivity(event: data)
            default:
                break
            }
        }
    }
    
    func setupListView() {
        provider.setupTableView(tableView: self.tableView)
    }
}


extension ProfileVC: ProfileUI {
    func load(with data: [ProfilePresenter.SectionType]) {
        provider.setData(data: data)
    }
}


extension ProfileVC {
    private func tableViewUserActivity(event: ProfileTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .editTapped:
            presenter.editUser()
        case .controlTapped(let type):
            presenter.handleControl(type: type)
        default:
            break
        }
    }
}
