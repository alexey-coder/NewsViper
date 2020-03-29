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
//💩
//extension RSSParserError: LocalizedError {
//    public var errorDescription: String? {
//        switch self {
//        case .invalidUrl:
//            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
//        case .parseError:
//            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
//        case .sourseError:
//            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
//        }
//    }
//}
