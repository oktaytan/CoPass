//
//  CoCategory.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 28.06.2023.
//

import UIKit

enum CoCategory: String, CustomStringConvertible, CaseIterable {
    case login
    case app
    case bank
    
    var description: String {
        switch self {
        case .login:
            return "password_category_login".localized
        case .app:
            return "password_category_app".localized
        case .bank:
            return "password_category_bank".localized
        }
    }
    
    var icon: UIImage {
        return UIImage(named: "\(rawValue)Icon")!
    }
}
