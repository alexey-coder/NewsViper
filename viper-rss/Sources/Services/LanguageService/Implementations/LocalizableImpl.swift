//
//  LocalizableImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

struct LocalizedImpl<T: Localizable> {
    private let localeKey: T
    private let languageTable: LanguageTable
    
    init(_ localeKey: T, languageTable: LanguageTable = LanguageTableImpl.shared) {
        self.localeKey = localeKey
        self.languageTable = languageTable
    }
    
    var text: String {
        return NSLocalizedString(localeKey.rawValue, tableName: languageTable.currentSupportedLanguageTable, comment: "")
    }
}
