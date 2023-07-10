//
//  StoreVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit
import CoreData

final class StoreVC: BaseViewController {
    
    typealias Presenter = StorePresenterProtocol
    typealias Provider = StoreTableViewProvider
    
    @IBOutlet weak var coSearchField: CoSearchField!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: Presenter!
    var provider: Provider!
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    override func setupUI() {
        super.setupUI()
        /// Search Field Listener
        self.coSearchField.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.searchBarUpdateUIStates(type: data)
            default:
                break
            }
        }
    }
}


extension StoreVC: StoreUI {
    func load(with data: [StorePresenter.SectionType]) {
        provider.setData(data: data)
    }
    
    func copyToPassword(password: String) {
        self.copyPassword(password: password)
    }
}


extension StoreVC {
    private func tableViewUserActivity(event: StoreTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .copiedRecord(let record):
            presenter.copyPassword(record: record)
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
    
    private func searchBarUpdateUIStates(type: CoSearchField.UserInteractivity?) {
        switch type {
        case .shouldChangeCharacters(let text):
            presenter.searchRecord(with: text)
        case .shouldClear(_):
            presenter.searchRecord(with: "")
        default:
            break
        }
    }
}
