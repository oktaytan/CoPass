//
//  CoTabBar.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import UIKit

protocol CoTabBarDelegate: AnyObject {
    func tapped(_ tag: Int)
    func addRecordTapped()
}

final class CoTabBar: BaseView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var addRecordButton: UIButton!
    
    weak var delegate: CoTabBarDelegate?
    
    var selectedIndex: Int = 0 {
        didSet {
            stackView.arrangedSubviews.forEach { view in
                if let btn = view as? UIButton {
                    btn.setImage(UIImage(named: "tabbar-\(btn.tag+1)")?.withRenderingMode(.alwaysOriginal), for: .normal)
                    btn.setImage(UIImage(named: "tabbar-\(btn.tag+1)")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
                    if btn.tag == selectedIndex {
                        btn.setImage(UIImage(named: "tabbar-\(selectedIndex+1)-selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
                        btn.setImage(UIImage(named: "tabbar-\(selectedIndex+1)-selected")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
                    }
                }
            }
        }
    }
    
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
        addRecordButton.backgroundColor = .white
        addRecordButton.setImage(UIImage(named: "tabbar-plus")!, for: .normal)
        addRecordButton.setImage(UIImage(named: "tabbar-plus")!, for: .highlighted)
        addRecordButton.configureShadow(shadowColor: .coText, offset: CGSize(width: 0, height: 0), shadowRadius: 8, shadowOpacity: 0.25, cornerRadius: AppConstants.appUIRadius + 4)
    }
    
    
    @IBAction func tapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        delegate?.tapped(sender.tag)
    }
    
    @IBAction func addRecordBtnTapped(_ sender: Any) {
        delegate?.addRecordTapped()
    }
}
