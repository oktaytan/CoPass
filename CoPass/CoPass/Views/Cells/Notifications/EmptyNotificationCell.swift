//
//  EmptyNotificationCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 15.07.2023.
//

import UIKit

class EmptyNotificationCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        messageLabel.text = Strings.emptyMessage
    }
}


extension EmptyNotificationCell {
    struct Strings {
        static let emptyMessage = "notify_empty_message".localized
    }
}
