//
//  ViewDataSource.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 27.06.2023.
//

import Foundation

protocol ViewDataSource {
    associatedtype ItemType
    
    var items: [ItemType] { get  set }
}

extension ViewDataSource {
    func item(at indexPath: IndexPath) -> ItemType {
        return items[(indexPath as NSIndexPath).item]
    }
}
