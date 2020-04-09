//
//  FeedViewModelFactory.swift
//  viper-rss
//
//  Created by user on 03.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

private struct Metrics {
    struct Patterns {
        static let storeFormat = Constants.Patterns.storeFormat
        static let customPattern = Constants.Patterns.customPattern
    }
}

final class FeedViewModelHelperImpl: FeedViewModelHelper {
    
    private let feedCellLayoutCalculator: LayoutCalculator
    private let imageLoaderService: ImageDownloadService
    
    init(
        feedCellLayoutCalculator: LayoutCalculator,
         imageLoaderService: ImageDownloadService) {
        self.feedCellLayoutCalculator = feedCellLayoutCalculator
        self.imageLoaderService = imageLoaderService
    }
    
    func produceViewModel(with entity: RSSEntity, fullMode: Bool) -> FeedViewModel {
        let sizes = self.feedCellLayoutCalculator.mesureCellHeight(
            title: entity.title, description: entity.description, date: entity.pubdate)
        
        let vm = FeedViewModelImpl(
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
        
        guard let url = URL(string: entity.imgUrl) else {
            return vm
        }
        
        imageLoaderService.image(for: url) { image in
            image.flatMap {
                vm.updateImgae($0)
            }
        }
        return vm
    }
    
    private func foratDate(dateToConvert: String) -> String {
        let fromFormatter = DateFormatter()
        fromFormatter.dateFormat = Metrics.Patterns.storeFormat
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

