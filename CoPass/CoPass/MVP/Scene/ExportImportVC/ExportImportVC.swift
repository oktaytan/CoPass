//
//  ExportImportVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 16.07.2023.
//

import UIKit

final class ExportImportVC: BaseViewController {
    
    typealias Presenter = ExportImportPresenter
    var presenter: Presenter!
    
    @IBOutlet weak var exportTitleLabel: UILabel!
    @IBOutlet weak var exportFileView: UIView!
    @IBOutlet weak var exportFileNameLabel: UILabel!
    @IBOutlet weak var exportMessageLabel: UILabel!
    @IBOutlet weak var exportBtn: CoButton!
    
    @IBOutlet weak var importTitleLabel: UILabel!
    @IBOutlet weak var importFileView: UIView!
    @IBOutlet weak var importFileNameLabel: UILabel!
    @IBOutlet weak var importMessageLabel: UILabel!
    @IBOutlet weak var importBtn: CoButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        self.showIndicator = true
        
        exportFileView.cornerRadius = AppConstants.appUIRadius
        importFileView.cornerRadius = AppConstants.appUIRadius
        
        exportTitleLabel.text = Strings.exportTitle
        importTitleLabel.text = Strings.importTitle
        
        exportBtn.type = .primary
        importBtn.type = .primary
        
        exportBtn.setTitle(Strings.exportTitle, for: .normal)
        importBtn.setTitle(Strings.importTitle, for: .normal)
        
        exportFileNameLabel.text = "\(AppConstants.appName).csv"
        importFileNameLabel.text = "\(AppConstants.appName).csv"
        
        exportMessageLabel.text = Strings.exportMessage
        importMessageLabel.text = Strings.importMessage
    }
    
    @IBAction func exportBtnTapped(_ sender: Any) {
        presenter.exportRecords()
    }
    
    @IBAction func importBtnTapped(_ sender: Any) {
        presenter.importRecords()
    }
}


extension ExportImportVC: ExportImportUI {
    
}


extension ExportImportVC {
    struct Strings {
        static let exportTitle = "export_title".localized
        static let exportMessage = "export_message".localized
        
        static let importTitle = "import_title".localized
        static let importMessage = "import_message".localized
    }
}
