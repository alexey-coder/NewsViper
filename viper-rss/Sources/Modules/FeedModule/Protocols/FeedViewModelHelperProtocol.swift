//
//  FeedViewModelHelperProtocol.swift
//  viper-rss
//
//  Created by user on 05.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol FeedViewModelHelperProtocol {
    func produceViewModel(with entity: RSSEntity, fullMode: Bool) -> FeedViewModelProtocol
}
