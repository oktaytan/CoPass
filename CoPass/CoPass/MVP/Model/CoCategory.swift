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
    
    var deselectedIcon: UIImage {
        return UIImage(named: "\(rawValue)IconGray")!
    }
    
    var copyIcon: UIImage {
        return UIImage(named: "copy_\(rawValue)Icon")!
    }
    
    var textColor: UIColor {
        switch self {
        case .app: return .coBlue
        case .bank: return .coOrange
        case .login: return .coPurple
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .app: return .coBlue10
        case .bank: return .coOrange10
        case .login: return .coPurple10
        }
    }
    
    var recordFields: [String] {
        switch self {
        case .app:
            return ["record_platform_app".localized, "record_entry_app".localized, "record_password_placeholder".localized]
        case .bank:
            return ["record_platform_bank".localized, "record_entry_bank".localized, "record_password_placeholder".localized]
        case .login:
            return ["record_platform_login".localized, "record_entry_login".localized, "record_password_placeholder".localized]
        }
    }
}
