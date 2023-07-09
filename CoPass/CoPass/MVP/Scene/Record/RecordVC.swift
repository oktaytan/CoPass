//
//  RecordVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit


final class RecordVC: BaseViewController {
    
    typealias Presenter = RecordPresenterProtocol
    typealias Provider = RecordTableViewProvider
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: CoButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var btnStackViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnStackViewRightConstraint: NSLayoutConstraint!
    
    var presenter: Presenter!
    var provider: Provider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        addObservationListener()
        setupListView()
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
        closeButton.setTitle(Strings.close, for: .normal)
        saveButton.setTitle(Strings.save, for: .normal)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        presenter.saveRecord()
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        deleteRecordDialog()
    }
}


extension RecordVC: RecordUI {
    func load(data: [RecordPresenter.SectionType], with status: RecordStatusType) {
        provider.setData(data: data)
        deleteButton.isHidden = status == .add
        btnStackViewLeftConstraint.constant = status == .add ? 60 : 20
        btnStackViewRightConstraint.constant = status == .add ? 60 : 20
    }
    
    func validation(status: Bool) {
        saveButton.type = status ? .primary : .disable
    }
}


extension RecordVC {
    private func tableViewUserActivity(event: RecordTableViewProviderImpl.UserInteractivity?) {
        switch event {
        case .selectedCategory(let category):
            presenter.selectedCategory(category: category)
        case .changeField(let type):
            presenter.changeField(type: type)
        default:
            break
        }
    }
    
    private func deleteRecordDialog() {
        let deletedAction = UIAlertAction(title: "dialog_delete".localized, style: .destructive) { [weak self] _ in
            self?.presenter.deleteRecord()
        }
        let cancelAction = UIAlertAction(title: "dialog_cancel".localized, style: .cancel)
        showDialog(message: "record_delete_confirm".localized, actions: [deletedAction, cancelAction])
    }
}


extension RecordVC {
    struct Strings {
        static let close = "close".localized
        static let save =  "save".localized
    }
}
