//
//  FeedViewModelImpl.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class FeedViewModelImpl: FeedViewModelProtocol {
    var newsTitleText: String
    var newsShortDescription: String
    var date: String
    var isFullMode: Bool
    var cellHeightFullMode: CGFloat
    var cellHeightSimpleMode: CGFloat
    var titleHeight: CGFloat
    var descriptionHeight: CGFloat
    var source: String
    var link: String
    var imgLink: String
    var isReaded: Bool
    
    init(
        newsTitleText: String,
        newsShortDescription: String,
        date: String,
        isFullMode: Bool,
        cellHeightFullMode: CGFloat,
        cellHeightSimpleMode: CGFloat,
        titleHeight: CGFloat,
        descriptionHeight: CGFloat,
        source: String,
        link: String,
        imgLink: String,
        isReaded: Bool) {
        
        self.newsTitleText = newsTitleText
        self.newsShortDescription = newsShortDescription
        self.date = date
        self.isFullMode = isFullMode
        self.cellHeightFullMode = cellHeightFullMode
        self.cellHeightSimpleMode = cellHeightSimpleMode
        self.titleHeight = titleHeight
        self.descriptionHeight = descriptionHeight
        self.source = source
        self.link = link
        self.imgLink = imgLink
        self.isReaded = isReaded
    }
}
