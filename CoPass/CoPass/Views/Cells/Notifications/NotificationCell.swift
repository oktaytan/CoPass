//
//  NotificationCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 15.07.2023.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.cornerRadius = AppConstants.appUIRadius
    }
    
    func set(data: CoNotification) {
        self.tintColor = data.type.textColor
        containerView.backgroundColor = data.type.bgColor
        iconImageView.image = data.type.icon
        titleLabel.text = data.type.description
        titleLabel.textColor = data.type.textColor
        messageLabel.text = data.message
    }
}
