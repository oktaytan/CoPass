//
//  ProfileTableViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 11.07.2023.
//

import UIKit
import ViewAnimator

protocol ProfileTableViewProvider {
    var stateClosure: ((ObservationType<ProfileTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [ProfilePresenter.SectionType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}

final class ProfileTableViewProviderImpl: NSObject, BaseTableViewProvider, ProfileTableViewProvider {
    
    typealias T = ProfilePresenter.SectionType
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
        let cells = [ProfileUserCell.self, ProfileControlCell.self, ProfileBrandCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.sectionHeaderTopPadding = 0
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
    }
}


extension ProfileTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        case editTapped, controlTapped(type: CoControlType)
    }
}


// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension ProfileTableViewProviderImpl: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = dataList?[section] else { return 0 }
        switch sectionType {
        case .user, .brand: return 1
        case .controls(let rows): return rows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = dataList?[indexPath.section] else { return UITableViewCell() }
        switch sectionType {
        case .user(let data):
            let cell = tableView.dequeueReusableCell(with: ProfileUserCell.self, for: indexPath)
            cell.set(with: data, delegate: self)
            return cell
        case .controls(let rows):
            return getCellForRow(tableView, rows: rows, at: indexPath)
        case .brand(let name, let date):
            let cell = tableView.dequeueReusableCell(with: ProfileBrandCell.self, for: indexPath)
            cell.set(name: name, date: date)
            return cell
        }
    }
    
    private func getCellForRow(_ tableView: UITableView, rows: [ProfilePresenter.RowType], at indexPath: IndexPath) -> UITableViewCell {
        let rowType = rows[indexPath.row]
        switch rowType {
        case .control(let type):
            let cell = tableView.dequeueReusableCell(with: ProfileControlCell.self, for: indexPath)
            cell.set(with: type)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = dataList?[indexPath.section] else { return }
        switch sectionType {
        case .controls(let rows):
            let rowType = rows[indexPath.row]
            switch rowType {
            case .control(let type):
                stateClosure?(.updateUI(data: .controlTapped(type: type)))
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = dataList?[indexPath.section] else { return }
        switch sectionType {
        case .user, .brand: cell.setFromAnimation(index: indexPath.row)
        case .controls: cell.setFromAnimation(index: indexPath.row)
        }
    }
}


extension ProfileTableViewProviderImpl: ProfileUserCellDelegate {
    func action(_ event: ProfileUserCell.UserActionEvent) {
        switch event {
        case .editTapped:
            stateClosure?(.updateUI(data: .editTapped))
        }
    }
}
