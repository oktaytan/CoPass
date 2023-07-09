//
//  RecordEntity.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 28.06.2023.
//

import Foundation

struct RecordEntity {
    var platform: String
    var entry: String
    var password: String
    var category: CoCategory
    
    init(platform: String = "", entry: String = "", password: String = "", category: CoCategory = .app) {
        self.platform = platform
        self.entry = entry
        self.password = password
        self.category = category
    }
    
    init(data: Record) {
        self.platform = data.platform
        self.entry = data.entry
        self.password = try! data.password.aesDecrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
        self.category = CoCategory(rawValue: data.category) ?? .app
    }
}
