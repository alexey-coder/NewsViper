//
//  FeedViewModelFactory.swift
//  viper-rss
//
//  Created by user on 03.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol FeedViewModelFactoryProtocol {
    func produceViewModel(with entity: RSSEntity, fullMode: Bool) -> FeedViewModelProtocol
}

private struct Metrics {
    struct Patterns {
        static let sourceDatePattern = Constants.Patterns.sourceDatePattern
        static let customPattern = Constants.Patterns.customPattern
    }
}

final class FeedViewModelFactoryImpl: FeedViewModelFactoryProtocol {
    
    private let feedCellLayoutCalculator: LayoutCalculatorProtocol

    init(feedCellLayoutCalculator: LayoutCalculatorProtocol) {
        self.feedCellLayoutCalculator = feedCellLayoutCalculator
    }
    
    func produceViewModel(with entity: RSSEntity, fullMode: Bool) -> FeedViewModelProtocol {
        let sizes = self.feedCellLayoutCalculator.mesureCellHeight(
            title: entity.title, description: entity.description, date: entity.pubdate)
        
        return FeedViewModelImpl(
            newsTitleText: entity.title,
            newsShortDescription: entity.description,
            date: foratDate(dateToConvert: entity.pubdate),
            isFullMode: fullMode,
            cellHeightFullMode: sizes.cellHeightFullMode,
            cellHeightSimpleMode: sizes.cellHeightSimpleMode,
            titleHeight: sizes.titleHeight,
            descriptionHeight: sizes.descriptionHeight,
            source: entity.source,
            link: entity.link,
            imgLink: entity.imgUrl,
            isReaded: entity.isReaded)
    }
    
    private func foratDate(dateToConvert: String) -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = Metrics.Patterns.sourceDatePattern
        let toFormetter = DateFormatter()
        toFormetter.dateFormat = Metrics.Patterns.customPattern
        if let date = fromFormatter.date(from: dateToConvert) {
            return toFormetter.string(from: date)
        } else {
            print("There was an error decoding the string")
            return dateToConvert
        }
    }
}
