//
//  UserDefaultsStorageProtocol.swift
//  viper-rss
//
//  Created by user on 01.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol UserDefaultsStorageProtocol {
    func savedSourceValue() -> String?
    func saveSourceValue(with value: String)
    func savedTimerValue() -> Int?
    func saveTimerValue(with value: Int)
}
