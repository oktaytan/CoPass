//
//  ProfileControlCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import UIKit

class ProfileControlCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var controlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(with type: CoControlType) {
        iconImageView.image = type.icon
        controlLabel.text = type.description
    }
}
