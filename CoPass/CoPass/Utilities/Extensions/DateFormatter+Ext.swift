//
//  DateFormatter+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import Foundation


extension DateFormatter {
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}
