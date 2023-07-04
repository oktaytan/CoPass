//
//  CoSafetyType.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 3.07.2023.
//

import UIKit

enum CoSafetyType {
    case best
    case good
    case normal
    case bad
    case critic
    case outOfRange
    
    static func getScoreType(_ score: Double) -> CoSafetyType {
        switch score {
        case 0...19: return .critic
        case 20...39: return .bad
        case 40...59: return .normal
        case 60...79: return .good
        case 80...100: return .best
        default: return .outOfRange
        }
    }
    
    var color: UIColor {
        switch self {
        case .best: return .coGreen
        case .good: return .coPurple
        case .normal: return .coOrange
        case .bad, .critic: return .coRed
        case .outOfRange: return .coTextGray
        }
    }
    
    var bg: UIColor {
        switch self {
        case .best: return .coGreen10
        case .good: return .coPurple10
        case .normal: return .coOrange10
        case .bad, .critic: return .coRed10
        case .outOfRange: return .coTextGray
        }
    }
}
