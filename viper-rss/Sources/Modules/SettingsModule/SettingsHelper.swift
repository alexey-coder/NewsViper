//
//  SettingsHelper.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

enum SettingsHelper: Int, CaseIterable {
    case timer
    case category
    
    static func getNumRows() -> Int {
        return self.allCases.count
    }
    
    func getTitle() -> String {
        switch self {
        case .timer:
            return LocalizedImpl<SettingsModuleLocalizedKeys>(.timer).text
        case .category:
            return LocalizedImpl<SettingsModuleLocalizedKeys>(.source).text
        }
    }
}

