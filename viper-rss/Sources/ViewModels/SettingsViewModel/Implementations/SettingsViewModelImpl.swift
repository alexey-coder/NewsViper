//
//  SettingsViewModelImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class SettingsViewModelImpl: SettingsTimerViewModelProtocol {
    var currentValue: String
    var labelText: String

    init(labelText: String, currentValue: String) {
        self.labelText = labelText
        self.currentValue = currentValue
    }
}
