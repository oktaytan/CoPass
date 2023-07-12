//
//  Date+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import Foundation

extension Date {
    func toString (dateFormatter: DateFormatter) -> String? {
        return dateFormatter.string(from: self)
    }
}
