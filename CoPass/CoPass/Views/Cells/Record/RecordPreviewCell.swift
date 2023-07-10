//
//  RecordPreviewCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 9.07.2023.
//

import UIKit

class RecordPreviewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    
    private var category: CoCategory = .app
    
    var platform: String = "" {
        didSet {
            platformLabel.text = platform.isEmpty ? category.recordFields[0] : platform
        }
    }
    
    var entry: String = "" {
        didSet {
            entryLabel.text = entry.isEmpty ? category.recordFields[1] : entry
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.cornerRadius = AppConstants.appUIRadius
        iconImageView.applyCircle()
    }
    
    func set(record: RecordEntity) {
        self.category = record.category
        containerView.backgroundColor = self.category.bgColor
        iconImageView.image = self.category.icon
        copyBtn.setImage(self.category.copyIcon, for: .normal)
        copyBtn.setImage(self.category.copyIcon, for: .highlighted)
        self.platform = record.platform.isEmpty ? self.category.recordFields[0] : record.platform
        self.entry = record.entry.isEmpty ? self.category.recordFields[1] : record.entry
    }
}
