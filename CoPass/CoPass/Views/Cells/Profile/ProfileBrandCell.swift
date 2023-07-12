//
//  ProfileBrandCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import UIKit

class ProfileBrandCell: UITableViewCell {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(name: String, date: String?) {
        appNameLabel.text = name
        dateLabel.text = date
    }
}
