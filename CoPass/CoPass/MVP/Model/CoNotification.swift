//
//  CoNotification.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 14.07.2023.
//

import UIKit

enum CoNotificationType: String, CustomStringConvertible {
    case success, warning, danger
    
    var description: String {
        switch self {
        case .success: return "notify_success_title".localized
        case .warning: return "notify_warning_title".localized
        case .danger: return "notify_danger_title".localized
        }
    }
    
    var icon: UIImage {
        return UIImage(named: "\(self.rawValue)Icon")!
    }
    
    var bgColor: UIColor {
        switch self {
        case .success: return .coPurple10
        case .warning: return .coOrange10
        case .danger: return .coRed10
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .success: return .coPurple
        case .warning: return .coOrange
        case .danger: return .coRed
        }
    }
}

struct CoNotification {
    let id = UUID()
    let message: String
    let type: CoNotificationType
}
