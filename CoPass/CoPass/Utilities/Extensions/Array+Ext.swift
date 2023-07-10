//
//  Array+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 10.07.2023.
//

import Foundation


extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
