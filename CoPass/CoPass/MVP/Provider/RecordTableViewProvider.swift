//
//  RecordTableViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 8.07.2023.
//

import UIKit
import CoreData
import ViewAnimator

protocol RecordTableViewProvider {
    var stateClosure: ((ObservationType<RecordTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [RecordPresenter.SectionType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}

final class RecordTableViewProviderImpl: NSObject, BaseTableViewProvider, RecordTableViewProvider {
    
    typealias T = RecordPresenter.SectionType
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
        let cells = [RecordCategoryCell.self, RecordFieldCell.self, RecordPreviewCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.sectionHeaderTopPadding = 16
        self.tableView?.sectionFooterHeight = 0
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
}


extension RecordTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        case selectedCategory(category: CoCategory), changeField(type: CoRecordFieldType)
    }
}


// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension RecordTableViewProviderImpl: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = dataList?[indexPath.section] else { return UITableViewCell() }
        switch sectionType {
        case .categories(let data, let selectedCategory):
            let cell = tableView.dequeueReusableCell(with: RecordCategoryCell.self, for: indexPath)
            cell.set(data: data, selectedCategory: selectedCategory, delegate: self)
            return cell
        case .form(let record):
            let cell = tableView.dequeueReusableCell(with: RecordFieldCell.self, for: indexPath)
            cell.set(record: record, delegate: self)
            return cell
        case .preview(let record):
            let cell = tableView.dequeueReusableCell(with: RecordPreviewCell.self, for: indexPath)
            cell.set(record: record)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = dataList?[section] else { return nil }
        
        let titleView: CoSectionTitleView = CoSectionTitleView()
        switch sectionType {
        case .categories:
            titleView.configure(title: Strings.categoriesSectionTitle)
        case .form:
            titleView.configure(title: Strings.formSectionTitle)
        case .preview:
            titleView.configure(title: Strings.previewSectionTitle)
        }
        return titleView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = dataList?[indexPath.section] else { return }
        switch sectionType {
        case .preview:
            cell.setFromAnimation(index: indexPath.row, delay: 0.3)
            break
        default:
            break
        }
    }
}



extension RecordTableViewProviderImpl: RecordCategoryCellDelegate {
    func selected(category: CoCategory) {
        stateClosure?(.updateUI(data: .selectedCategory(category: category)))
        tableView?.reloadData()
    }
}


extension RecordTableViewProviderImpl: RecordFieldCellDelegate {
    func changeField(type: CoRecordFieldType) {
        stateClosure?(.updateUI(data: .changeField(type: type)))
        guard let previewCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 2)) as? RecordPreviewCell else { return }
        switch type {
        case .platform(let text):
            previewCell.platform = text
        case .entry(let text):
            previewCell.entry = text
       default:
            break
        }
    }
}


extension RecordTableViewProviderImpl {
    struct Strings {
        static let categoriesSectionTitle = "record_select_category_title".localized
        static let formSectionTitle = "record_form_title".localized
        static let previewSectionTitle = "record_prerview_title".localized
    }
}
