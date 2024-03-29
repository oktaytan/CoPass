//
//  Router.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import Foundation
import CoreData

enum Router {
    
    enum Onboarding {
        case register, login
    }
    
    enum Register {
        case login
    }
    
    enum Login {
        case tabBar
    }
    
    enum TabBar {
        case home, store, safety, profile
        case openRecordWith(id: NSManagedObjectID?)
        
        var index: Int {
            switch self {
            case .home: return 0
            case .store : return 1
            case .safety: return 2
            case .profile: return 3
            default: return 0
            }
        }
    }
    
    enum Home {
        case goToStoreWith(category: CoCategory),
        openRecordWith(id: NSManagedObjectID),
        goToNotifications
    }
    
    enum Store {
        case openRecordWith(id: NSManagedObjectID)
    }
    
    enum Records {
        case dismiss
    }
    
    enum Safety {
        case openRecordWith(id: NSManagedObjectID)
    }
    
    enum Profile {
        case goToUser, goToSettings, goToSync, goToNotifications, openShare, exportImport, openSendFeedback, goToHelp, goToLogin
    }
    
    enum User {
        case goToOnboarding
    }
    
    enum Notifications {
        case goToSafety(group: CoScoreGroup)
    }
    
    enum Feedback {
        case dismiss(completion: (() -> Void)?)
    }
    
    enum ExportImport {
        case dismiss, export(path: URL?, completion: ((Bool) -> Void))
    }
}
