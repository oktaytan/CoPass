//
//  HomeVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import UIKit
import CoreData

protocol HomeVCDelegate: AnyObject {
    func action(_ event: HomeVC.UserEvent)
}

extension HomeVCDelegate {
    func action(_ event: HomeVC.UserEvent) {}
}

final class HomeVC: BaseViewController {
    
    typealias Presenter = HomePresenterProtocol
    typealias Provider = HomeTableViewProvider
    typealias Delegate = HomeVCDelegate
    
    var presenter: Presenter!
    var provider: Provider!
    weak var delegate: Delegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        addObservationListener()
        setupListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavBar()
    }
    
    func inject(presenter: Presenter, provider: Provider, delegate: HomeVCDelegate) {
        self.presenter = presenter
        self.provider = provider
        self.delegate = delegate
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


extension HomeVC {
    private func tableViewUserActivity(event: HomeTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .goToProfile:
            delegate?.action(.goToProfile)
        case .goToNotification:
            print("Notification")
        case .goToSafetyScore:
            delegate?.action(.goToSafetyScore)
        case .selectedCategory(let category):
            presenter.goToStoreWith(category: category)
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
}


extension HomeVC {
    enum UserEvent {
        case goToProfile, goToSafetyScore
    }
}


extension HomeVC: HomeUI {
    func load(with data: [HomePresenter.SectionType]) {
        provider.setData(data: data)
    }
    
    func copyToPassword(password: String) {
        self.copyPassword(password: password)
    }
}
