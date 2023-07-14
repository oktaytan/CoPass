//
//  NotificationsVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import UIKit

final class NotificationsVC: BaseViewController {
    
    typealias Presenter = NotificationsPresenterProtocol
    typealias Provider = NotificationsTableViewProvider
    
    var presenter: Presenter!
    var provider: Provider!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        addObservationListener()
        setupListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
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


extension NotificationsVC: NotificationsUI {
    func load(notifications: [NotificationsPresenter.RowType]) {
        self.provider.setData(data: notifications)
    }
}


extension NotificationsVC {
    private func tableViewUserActivity(event: NotificationsTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .goToSafety(let entity):
            presenter.goToSafety(entity: entity)
        default:
            break
        }
    }
}
