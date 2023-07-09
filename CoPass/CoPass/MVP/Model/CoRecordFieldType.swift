//
//  CoRecordFieldType.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 9.07.2023.
//

import Foundation

enum CoRecordFieldType {
    case `default`, platform(text: String), entry(text: String), password(text: String)
    
    init?(identifier: String, text: String) {
        switch identifier {
        case "platform": self = .platform(text: text)
        case "entry": self = .entry(text: text)
        case "password": self = .password(text: text)
        default: self = .default
        }
    }
}
