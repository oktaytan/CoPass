//
//  EmptyRecordCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 5.07.2023.
//

import UIKit

class EmptyRecordCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var addRecordLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.cornerRadius = AppConstants.appUIRadius
        iconImageView.cornerRadius = 10
        messageLabel.text = Strings.noRecord
        addRecordLabel.text = Strings.lets_add_record
    }
}


extension EmptyRecordCell {
    struct Strings {
        static let noRecord = "no_record".localized
        static let lets_add_record = "lets_add_record".localized
    }
}
