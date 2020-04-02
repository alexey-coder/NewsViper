//
//  StorageServiceError.swift
//  viper-rss
//
//  Created by user on 02.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

public enum StorageServiceError: Error {
    case saveError
    case updateError
    case listEntitiesError
}
