//
//  FeedCellLayoutCalculator.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Fonts {
        static let newTitleFont = Constants.Fonts.newTitleFont
        static let newDescriptionFont = Constants.Fonts.newDescriptionFont
        static let dateFont = Constants.Fonts.dateFont
    }
    
    struct Sizes {
        static let topAndBottomMargin = Constants.Sizes.topAndBottomMargin
        static let leadingToImage = Constants.Sizes.leadingToImage
        static let fromImageToText = Constants.Sizes.fromImageToText
        static let imageSize = Constants.Sizes.imageSize
        static let spaceBetweenText = Constants.Sizes.spaceBetweenText
        static let spaceForCheckIndicator = Constants.Sizes.spaceForCheckIndicator
    }
}

public typealias CellSizes = (
    cellHeightFullMode: CGFloat,
    cellHeightSimpleMode: CGFloat,
    titleHeight: CGFloat,
    descriptionHeight: CGFloat,
    dateHeight: CGFloat)

final class FeedCellLayoutCalculatorImpl: LayoutCalculator {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func mesureCellHeight(title: String, description: String, date: String) -> CellSizes {
        let titleHeight = mesureTitleTextHeight(text: title)
        let descriptionHeight = mesureDescriptionTextHeight(text: description)
        let dateHeight = mesureDateTextHeight(text: date)
        let cellHeightFullMode = titleHeight + descriptionHeight + (Metrics.Sizes.topAndBottomMargin * 2) + Metrics.Sizes.spaceBetweenText + dateHeight
        let cellHeightSimpleMode = cellHeightFullMode - descriptionHeight
        return CellSizes(cellHeightFullMode, cellHeightSimpleMode, titleHeight, descriptionHeight, dateHeight)
    }
    
    private func mesureTitleTextHeight(text: String) -> CGFloat {
        let width = screenWidth - Metrics.Sizes.leadingToImage - Metrics.Sizes.imageSize - Metrics.Sizes.fromImageToText - Metrics.Sizes.spaceForCheckIndicator
        return text.height(width: width, font: Metrics.Fonts.newTitleFont!)
    }

    private func mesureDescriptionTextHeight(text: String) -> CGFloat {
        let width = screenWidth - Metrics.Sizes.leadingToImage - Metrics.Sizes.imageSize - Metrics.Sizes.fromImageToText - Metrics.Sizes.spaceForCheckIndicator
        return text.height(width: width, font: Metrics.Fonts.newDescriptionFont!)
    }
    
    private func mesureDateTextHeight(text: String) -> CGFloat {
        let width = (screenWidth - (Metrics.Sizes.leadingToImage * 2)) / 2
        return text.height(width: width, font: Metrics.Fonts.dateFont!)
    }
}
