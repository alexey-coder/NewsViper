//
//  LocalizableImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

struct LocalizedImpl<T: LocalizableProtocol> {
    private let localeKey: T
    private let languageTable: LanguageTableProtocol
    
    init(_ localeKey: T, languageTable: LanguageTableProtocol = LanguageTableImpl.shared) {
        self.localeKey = localeKey
        self.languageTable = languageTable
    }
    
    var text: String {
        return NSLocalizedString(localeKey.rawValue, tableName: languageTable.currentSupportedLanguageTable, comment: "")
    }
}
