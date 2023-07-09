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
    
    override func setupUI() {
        super.setupUI()
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
            deleteRecordDialog(id: id)
        default:
            break
        }
    }
    
    private func deleteRecordDialog(id: NSManagedObjectID) {
        let deletedAction = UIAlertAction(title: "dialog_delete".localized, style: .destructive) { [weak self] _ in
            self?.presenter.deleteRecord(id: id)
        }
        let cancelAction = UIAlertAction(title: "dialog_cancel".localized, style: .cancel)
        showDialog(message: "record_delete_confirm".localized, actions: [deletedAction, cancelAction])
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
        self.showBottomPopup(message: Strings.copyPassword)
        UIPasteboard.general.string = password
    }
}


extension HomeVC {
    struct Strings {
        static let copyPassword =  "password_copied".localized
    }
}
