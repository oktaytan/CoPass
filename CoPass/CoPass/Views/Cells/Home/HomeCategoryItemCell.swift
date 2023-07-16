//
//  HomeCategoryItemCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 3.07.2023.
//

import UIKit

class HomeCategoryItemCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryPasswordCountlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        containerView.cornerRadius = AppConstants.appUIRadius
        containerView.backgroundColor = .white
    }
    
    func set(with category: CoCategory, count: Int) {
        iconImageView.image = category.icon
        categoryTitleLabel.text = category.description
        let countText = count > 1 ? Strings.passwordCountPlural : Strings.passwordCountSingular
        categoryPasswordCountlabel.text = String(format: countText, count)
    }
}


extension HomeCategoryItemCell {
    struct Strings {
        static let passwordCountSingular = "password_count_singular".localized
        static let passwordCountPlural = "password_count_plural".localized
    }
}
