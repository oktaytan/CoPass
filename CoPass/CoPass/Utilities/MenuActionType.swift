//
//  MenuActionType.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 6.07.2023.
//

import UIKit
import CoreData

enum MenuActionType: CaseIterable {
    case copy, edit, delete
    
    var title: String {
        switch self {
        case .copy: return "Copy"
        case .edit: return "Edit"
        case .delete: return "Delete"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .copy: return UIImage(named: "copyIcon")!.withRenderingMode(.alwaysOriginal)
        case .edit: return UIImage(named: "editIcon")!.withRenderingMode(.alwaysOriginal)
        case .delete: return UIImage(named: "deleteIcon")!.withRenderingMode(.alwaysOriginal)
        }
    }
}
