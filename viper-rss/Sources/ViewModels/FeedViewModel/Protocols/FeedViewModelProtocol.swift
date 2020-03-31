//
//  FeedViewModelProtocol.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedViewModelProtocol {
    var cellHeightFullMode: CGFloat { get set }
    var cellHeightSimpleMode: CGFloat { get set }
    var titleHeight: CGFloat { get set }
    var descriptionHeight: CGFloat { get set }
    var source: String { get set }
    var newsTitleText: String { get set }
    var newsShortDescription: String { get set }
    var date: String { get set }
    var isFullMode: Bool { get set }
}
