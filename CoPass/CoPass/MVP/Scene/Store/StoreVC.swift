//
//  StoreVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit
import CoreData

protocol StoreVCDelegate: AnyObject {
    func action(_ event: StoreVC.UserEvent)
}

extension StoreVCDelegate {
    func action(_ event: StoreVC.UserEvent) {}
}

final class StoreVC: BaseViewController {
    
    typealias Presenter = StorePresenterProtocol
    typealias Provider = StoreTableViewProvider
    typealias Delegate = StoreVCDelegate
    
    @IBOutlet weak var coSearchField: CoSearchField!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: Presenter!
    var provider: Provider!
    weak var delegate: Delegate?
    
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
    
    func inject(presenter: Presenter, provider: Provider, delegate: StoreVCDelegate) {
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
    
    override func setupUI() {
        super.setupUI()
        
        coSearchField.placeholder = "Search"
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
        self.showBottomPopup(message: Strings.copyPassword)
        UIPasteboard.general.string = password
    }
}


extension StoreVC {
    enum UserEvent {
        case goToRecordWith(id: NSManagedObjectID)
    }
}


extension StoreVC {
    private func tableViewUserActivity(event: StoreTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .copiedRecord(let record):
            presenter.copyPassword(record: record)
        case .selectedRecord(let id):
            delegate?.action(.goToRecordWith(id: id))
        case .deleteRecord(let id):
            deleteRecordDialog(id: id)
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
    
    private func deleteRecordDialog(id: NSManagedObjectID) {
        let deletedAction = UIAlertAction(title: "dialog_delete".localized, style: .destructive) { [weak self] _ in
            self?.presenter.deleteRecord(id: id)
        }
        let cancelAction = UIAlertAction(title: "dialog_cancel".localized, style: .cancel)
        showDialog(message: "record_delete_confirm".localized, actions: [deletedAction, cancelAction])
    }
}


extension StoreVC {
    struct Strings {
        static let searchPlaceHolder = "store_search_place_holder".localized
        static let copyPassword =  "password_copied".localized
    }
}
