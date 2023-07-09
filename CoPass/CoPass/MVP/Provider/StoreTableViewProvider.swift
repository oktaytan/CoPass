//
//  StoreTableViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 5.07.2023.
//

import UIKit
import CoreData

protocol StoreTableViewProvider {
    var stateClosure: ((ObservationType<StoreTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [StorePresenter.SectionType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}

final class StoreTableViewProviderImpl: NSObject, BaseTableViewProvider, StoreTableViewProvider {
    
    typealias T = StorePresenter.SectionType
    typealias I = IndexPath
    
    var dataList: [T]?
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    var menuActionList = [MenuActionType]()
    
    private var tableView: UITableView?
    
    /// ViewModel' den view'e gelen datayı provider'a gönderir.
    /// - Parameter data: DealListPresenterOutput.RowType
    func setData(data: [T]?) {
        self.dataList = data
        tableViewReload()
        menuActionList = MenuActionType.allCases
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
        let cells = [RecordCell.self, EmptyRecordCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.sectionHeaderTopPadding = 16
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
}


extension StoreTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        case copiedRecord(Record), selectedRecord(id: NSManagedObjectID), deleteRecord(id: NSManagedObjectID)
    }
}


// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension StoreTableViewProviderImpl: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = dataList?[section] else { return 0 }
        switch sectionType {
        case .records(let rows, _): return rows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = dataList?[indexPath.section] else { return UITableViewCell() }
        switch sectionType {
        case .records(let rows, _):
            return getCellForRow(tableView, rows: rows, at: indexPath)
        }
    }
    
    private func getCellForRow(_ tableView: UITableView, rows: [StorePresenter.RowType], at indexPath: IndexPath) -> UITableViewCell {
        let rowType = rows[indexPath.row]
        switch rowType {
        case .record(let data):
            let cell = tableView.dequeueReusableCell(with: RecordCell.self, for: indexPath)
            cell.set(record: data, delegate: self)
            return cell
        case .emptyRecord:
            let cell = tableView.dequeueReusableCell(with: EmptyRecordCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = dataList?[indexPath.section] else { return }
        
        switch sectionType {
        case .records(let rows, _):
            let row = rows[indexPath.row]
            switch row {
            case .record(let data):
                stateClosure?(.updateUI(data: .selectedRecord(id: data.objectID)))
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = dataList?[section] else { return nil }
        switch sectionType {
        case .records(_, let title):
            let titleView: CoSectionTitleView = CoSectionTitleView()
            titleView.configure(title: title)
            return titleView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = dataList?[section] else { return 0.0 }
        switch sectionType {
        case .records: return 32.0
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let sectionType = dataList?[indexPath.section] else { return nil }
        switch sectionType {
        case .records(let rows, _):
            let rowType = rows[indexPath.row]
            switch rowType {
            case .record(let data): return setContextMenu(data: data)
            default:
                return nil
            }
        }
    }
    
    private func setContextMenu(data: Record) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return nil }
            
            let menuElementList: [UIMenuElement] = menuActionList.map { actionType in
                
                let action = UIAction(title: actionType.title, image: actionType.icon) { [weak self] _ in
                    switch actionType {
                    case .copy:
                        self?.stateClosure?(.updateUI(data: .copiedRecord(data)))
                    case .edit:
                        self?.stateClosure?(.updateUI(data: .selectedRecord(id: data.objectID)))
                    case .delete:
                        self?.stateClosure?(.updateUI(data: .deleteRecord(id: data.objectID)))
                    }
                }
                
                return action
            }
            
            let menu = UIMenu(children: menuElementList)
            return menu
        }
        
        return config
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = dataList?[indexPath.section] else { return }
        switch sectionType {
        case .records(let rows, _):
            let rowType = rows[indexPath.row]
            switch rowType {
            case .record:
                cell.setFromAnimation(index: indexPath.row)
                break
            default: break
            }
        }
    }
}


extension StoreTableViewProviderImpl: RecordCellDelegate {
    func copied(record: Record) {
        stateClosure?(.updateUI(data: .copiedRecord(record)))
    }
}
