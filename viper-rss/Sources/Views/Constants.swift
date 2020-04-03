//
//  Constants.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

struct Constants {
    struct Sizes {
        static let topAndBottomMargin: CGFloat = 16
        static let leadingToImage: CGFloat = 16
        static let fromImageToText: CGFloat = 36
        static let imageSize: CGFloat = 56
        static let spaceBetweenText: CGFloat = 16
    }
    
    struct Fonts {
        static let newTitleFont = FontHelper.Bold.of(size: 16)
        static let newDescriptionFont = FontHelper.Regular.of(size: 10)
        static let dateFont = FontHelper.Bold.of(size: 10)
        static let sourceFont = FontHelper.Bold.of(size: 10)
    }
    
    struct Colors {
        static let tintColor = ColorHelper.tintColor
        static let newsTitleColor = ColorHelper.newsBaseTextColor
        static let newsDescriptionColor = ColorHelper.newsDescriptionColor
        static let backgroundColor = ColorHelper.baseBackgroundColor
        static let dateColor = ColorHelper.newsBaseTextColor
        static let sourceColor = ColorHelper.newsBaseTextColor
        static let settingsSecondaryColor = ColorHelper.secondaryTextColor
    }
    
    struct DefaultValues {
        static let timerDefault: Int = Constants.DefaultValues.timers.first!
        static let sourceDefault: String = "all"
        static let timers: [Int] = [15, 30, 60]
        static let sources: [String] = Sources.allValues
    }
    
    struct Patterns {
        static let sourceDatePattern = "E, d MMM yyyy HH:mm:ss Z"
        static let customPattern = "dd.MM.yy"
    }
}
