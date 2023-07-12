//
//  CoControlType.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 11.07.2023.
//

import UIKit


enum CoControlType: String, CustomStringConvertible, CaseIterable {
    case settings, sync, notifications, share, exportImport, feedback, help, logout
    
    var description: String {
        switch self {
        case .settings: return "profile_control_settings".localized
        case .sync: return "profile_control_sync".localized
        case .notifications: return "profile_control_notifications".localized
        case .share: return "profile_control_share".localized
        case .exportImport: return "profile_control_export_import".localized
        case .feedback: return "profile_control_feedback".localized
        case .help: return "profile_control_help".localized
        case .logout: return "profile_control_logout".localized
        }
    }
    
    var icon: UIImage {
        return UIImage(named: "\(self.rawValue)Icon")!
    }
    
    var textColor: UIColor {
        switch self {
        case .logout: return .coRed
        default: return .coText
        }
    }
}
