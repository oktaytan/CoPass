//
//  CoButton.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 20.05.2023.
//

import UIKit

final class CoButton: UIButton {
    
    enum CoButtonType {
        case primary, secondary, delete
        
        var bgColor: UIColor {
            switch self {
            case .primary: return .coPurple
            case .secondary: return .coOrange
            case .delete: return .coRed10
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .primary: return .white
            case .secondary: return .white
            case .delete: return .coRed
            }
        }
    }
    
    var type: CoButtonType = .primary {
        didSet {
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupUI() {
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        setTitleColor(type.titleColor, for: .normal)
        backgroundColor = type.bgColor
        cornerRadius = AppConstants.appUIRadius
    }
    
}
