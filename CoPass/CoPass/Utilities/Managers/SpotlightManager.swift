//
//  SpotlightManager.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 31.07.2023.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class SpotlightManager {
    let domainIdentifier = "com.oktaytan.CoPass"
    
    static let shared = SpotlightManager()
    
    private init() {}
    
    public func configureSearchableItems() {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
        
        attributeSet.title = AppConstants.appName
        attributeSet.contentDescription = "spotlight_content".localized
        attributeSet.relatedUniqueIdentifier = UUID().uuidString
        attributeSet.keywords = ["pass", "paste", "password", "password manager", "secure"]
        
        let searchableItem = CSSearchableItem(uniqueIdentifier: UUID().uuidString, domainIdentifier: "com.oktaytan.CoPass", attributeSet: attributeSet)
        indexSearchableItems(items: [searchableItem])
    }
    
    private func indexSearchableItems(items: [CSSearchableItem]) {
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                debugPrint(error)
            } else {
                debugPrint("indexing successful")
            }
        }
    }
    
    private func deleteIndexedSearchableItems() {
        CSSearchableIndex.default().deleteAllSearchableItems { error in
            if let error = error {
                debugPrint(error)
            } else {
                debugPrint("index deleted successfully")
            }
        }
    }
}
