//
//  NotificationsTableViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 15.07.2023.
//

import UIKit
import ViewAnimator

protocol NotificationsTableViewProvider {
    var stateClosure: ((ObservationType<NotificationsTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [NotificationsPresenter.RowType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}

final class NotificationsTableViewProviderImpl: NSObject, BaseTableViewProvider, NotificationsTableViewProvider {
    
    typealias T = NotificationsPresenter.RowType
    typealias I = IndexPath
    
    var dataList: [T]?
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    
    private var tableView: UITableView?
    
    /// ViewModel' den view'e gelen datayı provider'a gönderir.
    /// - Parameter data: DealListPresenterOutput.RowType
    func setData(data: [T]?) {
        self.dataList = data
        tableViewReload()
    }
    
    /// TableView'i reload eder.
    func tableViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    /// TableView'in delegate ve datasource özelliklerini setler. Cell register işlemlerini gerçekleştirir.
    /// - Parameter tableView: UITableView
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        let cells = [NotificationCell.self, EmptyNotificationCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.sectionHeaderTopPadding = 0
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
    }
}


extension NotificationsTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        case goToSafety(entity: CoNotification)
    }
}


// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension NotificationsTableViewProviderImpl: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = dataList?[indexPath.row] else { return UITableViewCell() }
        switch rowType {
        case .notification(let entity):
            let cell = tableView.dequeueReusableCell(with: NotificationCell.self, for: indexPath)
            cell.set(data: entity)
            return cell
        case .empty:
            let cell = tableView.dequeueReusableCell(with: EmptyNotificationCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rowType = dataList?[indexPath.row] else { return }
        switch rowType {
        case .notification(let entity):
            stateClosure?(.updateUI(data: .goToSafety(entity: entity)))
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setFromAnimation(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CoSectionTitleView()
        view.configure(title: Strings.title, font: .systemFont(ofSize: 26, weight: .bold))
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}


extension NotificationsTableViewProviderImpl {
    struct Strings {
        static let title = "notify_screen_title".localized
    }
}
