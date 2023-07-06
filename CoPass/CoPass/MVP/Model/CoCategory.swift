//
//  CoCategory.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 28.06.2023.
//

import UIKit

enum CoCategory: String, CustomStringConvertible, CaseIterable {
    case app
    case bank
    case login
    
    var description: String {
        switch self {
        case .app:
            return "password_category_app".localized
        case .bank:
            return "password_category_bank".localized
        case .login:
            return "password_category_login".localized
        }
    }
    
    var icon: UIImage {
        return UIImage(named: "\(rawValue)Icon")!
    }
    
    var copyIcon: UIImage {
        return UIImage(named: "copy_\(rawValue)Icon")!
    }
    
    var bgColor: UIColor {
        switch self {
        case .app: return .coBlue10
        case .bank: return .coOrange10
        case .login: return .coPurple10
        }
    }
}
