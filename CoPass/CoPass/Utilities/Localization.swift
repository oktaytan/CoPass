//
//  Localization.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

extension String {
    
    var localized: String {
        Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
}

extension Bundle {
    static var localizedBundle: Bundle {
        let languageCode = Language.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        
        return Bundle(path: path) ?? Bundle.main
    }
}
