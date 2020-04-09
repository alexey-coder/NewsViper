//
//  UserDefaultsImpl.swift
//  viper-rss
//
//  Created by user on 01.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class UserDefaultsStorageImpl: UserDefaultsStorage {
    
    private let kSavedSourceValue = "kSavedSourceValue"
    private let kSavedTimerValue = "kSavedTimerValue"
    
    
    func savedSourceValue() -> String? {
        if UserDefaults.standard.object(forKey: kSavedSourceValue) != nil {
            return UserDefaults.standard.string(forKey: kSavedSourceValue);
        }
        return nil
    }
    
    func saveSourceValue(with value: String) {
        UserDefaults.standard.set(value, forKey: kSavedSourceValue)
        UserDefaults.standard.synchronize()
    }
    
    func savedTimerValue() -> Int? {
        if UserDefaults.standard.object(forKey: kSavedTimerValue) != nil {
            return UserDefaults.standard.integer(forKey: kSavedTimerValue)
        }
        return nil
    }
    
    func saveTimerValue(with value: Int) {
        UserDefaults.standard.set(value, forKey: kSavedTimerValue)
        UserDefaults.standard.synchronize()
    }
}
