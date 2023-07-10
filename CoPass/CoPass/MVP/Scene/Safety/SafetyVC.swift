//
//  SafetyVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit
import CoreData

final class SafetyVC: BaseViewController {
    
    typealias Presenter = SafetyPresenterProtocol
    typealias Provider = SafetyTableViewProvider
    
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


extension SafetyVC: SafetyUI {
    func load(with data: [SafetyPresenter.SectionType]) {
        provider.setData(data: data)
    }
    
    func copyToPassword(password: String) {
        self.copyPassword(password: password)
    }
}


extension SafetyVC {
    private func tableViewUserActivity(event: SafetyTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .copiedRecord(let record):
            presenter.copyPassword(record: record)
        case .changeGroup(let group):
            presenter.changeGroup(group: group)
        case .selectedRecord(let id):
            presenter.goToRecord(id: id)
        case .deleteRecord(let id):
            deleteRecordDialog() { [weak self] status in
                guard status else { return }
                self?.presenter.deleteRecord(id: id)
            }
        default:
            break
        }
    }
}
