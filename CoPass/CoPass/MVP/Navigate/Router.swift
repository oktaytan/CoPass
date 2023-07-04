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
        case openStoreWith(category: CoCategory)
        
        var index: Int {
            switch self {
            case .home: return 0
            case .store, .openStoreWith: return 1
            case .safety: return 2
            case .profile: return 3
            default: return 0
            }
        }
    }
    
    enum Home {
        
    }
    
    enum Store {
        
    }
    
    enum Records {
        
    }
    
    enum Safety {
        
    }
    
    enum Profile {
        
    }
}
