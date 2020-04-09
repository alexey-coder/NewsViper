//
//  LanguageTableImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class LanguageTableImpl: LanguageTable {
    
    static let shared = LanguageTableImpl()
    
    private static let defaultLanguageTablePrefix = "Localizable"
    
    private let preferredLanguage: String
    
    private init(preferredLanguage: String = Locale.preferredLanguages.first ?? "") {
        self.preferredLanguage = preferredLanguage
    }
    
    lazy var currentSupportedLanguageTable: String = {
        let preferredLanguageWithoutRegion =
            preferredLanguage.split(separator: "-").first ?? ""
        let languageTableFile = "\(LanguageTableImpl.defaultLanguageTablePrefix)-\(String(preferredLanguageWithoutRegion).uppercased())"
        if Bundle.main.path(forResource: languageTableFile, ofType: "strings") != nil {
            return languageTableFile
        } else {
            return "\(LanguageTableImpl.defaultLanguageTablePrefix)-EN"
        }
    }()
}
