//
//  HomeTableViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//

import UIKit
import CoreData
import ViewAnimator

protocol HomeTableViewProvider {
    var stateClosure: ((ObservationType<HomeTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [HomePresenter.SectionType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}

final class HomeTableViewProviderImpl: NSObject, BaseTableViewProvider, HomeTableViewProvider {
    
    typealias T = HomePresenter.SectionType
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
            self?.setAnimation()
        }
    }
    
    /// TableView'in delegate ve datasource özelliklerini setler. Cell register işlemlerini gerçekleştirir.
    /// - Parameter tableView: UITableView
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        let cells = [HomeUserCell.self, HomeSafetyScoreCell.self, HomeCategoryCell.self, RecordCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.sectionHeaderTopPadding = 16
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    private func setAnimation() {
        guard let numberOfSections = self.tableView?.numberOfSections else { return }
        let fromAnimation = AnimationType.from(direction: .left, offset: 100)
        
        for i in (0..<numberOfSections) {
            guard let cells = self.tableView?.visibleCells(in: i) else { return }
            UIView.animate(views: cells, animations: [fromAnimation], initialAlpha: 0.0, finalAlpha: 1.0, delay: (0.1 * Double(i)), duration: 0.25)
        }
    }
}


extension HomeTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        case goToProfile, goToNotification, goToSafetyScore, selectedCategory(_ category: CoCategory), copiedRecord(Record), selectedRecord(id: NSManagedObjectID)
    }
}


// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension HomeTableViewProviderImpl: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = dataList?[section] else { return 0 }
        switch sectionType {
        case .recentlyAdded(let rows, _): return rows.count
        default: return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = dataList?[indexPath.section] else { return UITableViewCell() }
        
        switch sectionType {
        case .user(let data):
            let cell = tableView.dequeueReusableCell(with: HomeUserCell.self, for: indexPath)
            cell.setup(user: data, delegate: self)
            return cell
        case .safetyScore(let score, let count, let type):
            let cell = tableView.dequeueReusableCell(with: HomeSafetyScoreCell.self, for: indexPath)
            cell.setScore(with: score, count: count, type: type)
            return cell
        case .categories(let data, _):
            let cell = tableView.dequeueReusableCell(with: HomeCategoryCell.self, for: indexPath)
            cell.set(with: data, delegate: self)
            return cell
        case .recentlyAdded(let rows, _):
            return getCellForRow(tableView, rows: rows, at: indexPath)
        }
    }
    
    private func getCellForRow(_ tableView: UITableView, rows: [HomePresenter.RowType], at indexPath: IndexPath) -> UITableViewCell {
        let rowType = rows[indexPath.row]
        switch rowType {
        case .record(let data):
            let cell = tableView.dequeueReusableCell(with: RecordCell.self, for: indexPath)
            cell.set(record: data, delegate: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = dataList?[indexPath.section] else { return }
        
        switch sectionType {
        case .safetyScore:
            stateClosure?(.updateUI(data: .goToSafetyScore))
        case .recentlyAdded(let rows, _):
            let row = rows[indexPath.row]
            switch row {
            case .record(let data):
                stateClosure?(.updateUI(data: .selectedRecord(id: data.objectID)))
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = dataList?[section] else { return nil }
        switch sectionType {
        case .categories(_, let title), .recentlyAdded(_, let title):
            let titleView: CoSectionTitleView = CoSectionTitleView()
            titleView.configure(title: title)
            return titleView
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = dataList?[section] else { return 0.0 }
        switch sectionType {
        case .categories, .recentlyAdded:
            return 32
        default: return 0.0
        }
    }
}


extension HomeTableViewProviderImpl: HomeUserCellDelegate {
    func action(_ event: HomeUserCell.UserActionEvent) {
        switch event {
        case .avatarTapped:
            stateClosure?(.updateUI(data: .goToProfile))
        case .notifyTapped:
            stateClosure?(.updateUI(data: .goToNotification))
        }
    }
}


extension HomeTableViewProviderImpl: HomeCategoryCellDelegate {
    func select(_ category: CoCategory) {
        stateClosure?(.updateUI(data: .selectedCategory(category)))
    }
}


extension HomeTableViewProviderImpl: RecordCellDelegate {
    func copied(record: Record) {
        stateClosure?(.updateUI(data: .copiedRecord(record)))
    }
}
