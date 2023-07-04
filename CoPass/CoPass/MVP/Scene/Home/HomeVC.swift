//
//  HomeVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import UIKit
import SkeletonView
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
        tableView.isSkeletonable = true
        tableView.startSkeletonAnimation()
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
            delegate?.action(.goToStore(for: category))
        case .copiedRecord(let record):
            presenter.copyPassword(record: record)
        case .selectedRecord(let id):
            delegate?.action(.goToRecordWith(id: id))
        default:
            break
        }
    }
}


extension HomeVC {
    enum UserEvent {
        case goToProfile, goToSafetyScore, goToStore(for: CoCategory), goToRecordWith(id: NSManagedObjectID)
    }
}


extension HomeVC: HomeUI {
    func load(with data: [HomePresenter.SectionType]) {
        provider.setData(data: data)
    }
}
