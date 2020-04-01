//
//  RSSParserError.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

public enum RSSParserError: Error {
    case invalidUrl
    case parseError
    case sourseError
}
