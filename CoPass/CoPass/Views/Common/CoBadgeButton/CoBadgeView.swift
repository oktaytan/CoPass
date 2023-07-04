//
//  CoBadgeView.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 1.07.2023.
//

import UIKit

protocol BadgeConfigurable {
    func setBadge(with value: Int)
    func increment()
    func decrement()
}

final class CoBadgeView: BaseView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    var badgeValue: Int = 0 {
        didSet {
            badgeLabel.text = "\(badgeValue)"
            badgeView.isHidden = badgeValue == 0
        }
    }
    
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.badgeView.cornerRadius = 10.0
        self.badgeView.addBorder(color: .white, width: 1)
        self.clipsToBounds = false
    }
    
    func configure(image: String, badgeValue: Int = 0, hasAction: Bool = true) {
        self.setBadge(with: badgeValue)
        self.imageView.image = UIImage(named: image)!
        self.actionBtn.isEnabled = hasAction
        self.actionBtn.isUserInteractionEnabled = hasAction
    }
    
    @IBAction func tapped(_ sender: Any) {
        action?()
    }
}


extension CoBadgeView: BadgeConfigurable {
    func setBadge(with value: Int) {
        self.badgeValue = value
    }
    
    func increment() {
        self.badgeValue += 1
    }
    
    func decrement() {
        if self.badgeValue == 0 { return }
        self.badgeValue -= 1
    }
}
