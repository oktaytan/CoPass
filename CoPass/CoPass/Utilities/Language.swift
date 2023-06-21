//
//  Language.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

public enum Language: String, CaseIterable {
  
  case english = "en"
  case turkish = "tr"

  var description: String {
    switch self {
    case .english:
      return "english".localized
    case .turkish:
      return "turkish".localized
    }
  }
  
  
  static var language: Language {
    get {
      if let languageCode = UserDefaults.standard.string(forKey: AppConstants.appleLanguagesKey),
        let language = Language(rawValue: languageCode) {
        return language
      } else {
        let preferredLanguage = Locale.preferredLanguages[0] as String
        let index = preferredLanguage.index(preferredLanguage.startIndex, offsetBy: 2)
        
        guard let localization = Language(rawValue: String(preferredLanguage[..<index])) else {
          return Language.english
        }
        
        return localization
      }
    }
    set {
      guard language != newValue else {
        return
      }
      
      //change language in the app
      //the language will be changed after restart
      UserDefaults.standard.set([newValue.rawValue], forKey: AppConstants.appleLanguagesKey)
      UserDefaults.standard.synchronize()
    }
  }
}
