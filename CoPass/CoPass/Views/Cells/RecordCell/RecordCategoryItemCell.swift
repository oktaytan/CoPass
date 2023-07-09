//
//  RecordCategoryItemCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 8.07.2023.
//

import UIKit

class RecordCategoryItemCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(data: CoCategory, isSelected: Bool) {
        self.isSelected = isSelected
        iconImageView.image = isSelected ? data.icon : data.deselectedIcon
        categoryLabel.text = data.description
        categoryLabel.textColor = isSelected ? data.textColor : .coTextGray
    }
}
