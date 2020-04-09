//
//  RSSParserService.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol RSSParserService {
    func parseFeed(url: String, successCompletion: @escaping ((RSSEntity) -> Void), errorCompletion: @escaping ((RSSParserError) -> Void))
}
