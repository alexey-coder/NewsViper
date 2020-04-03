//
//  SettingsViewModelFactory.swift
//  viper-rss
//
//  Created by user on 03.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

private struct Metrics {
    struct Values {
        static let timerDefaultValue = Constants.DefaultValues.timerDefault
        static let sourceDefaultValue = Constants.DefaultValues.sourceDefault
        static let sources = Constants.DefaultValues.sources
        static let timers = Constants.DefaultValues.timers
    }
}

final class SettingsViewModelFactory: SettingsViewModelFactoryProtocol {
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func produceViewModel(by indexPath: IndexPath) -> SettingsTimerViewModelProtocol? {
        
        guard let row = SettingsHelper(rawValue: indexPath.row) else {
            return nil
        }
        let currentValue: String
        switch row {
        case .timer:
            if let currentTimerValue = userDefaultsStorage.savedTimerValue() {
                currentValue = String(describing: currentTimerValue)
            } else {
                currentValue = String(describing: Metrics.Values.timerDefaultValue)
            }
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: currentValue)
        case .source:
            if let currentSource = userDefaultsStorage.savedSourceValue() {
                currentValue = currentSource
            } else {
                currentValue = Metrics.Values.sourceDefaultValue
            }
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: currentValue)
        }
    }
}
