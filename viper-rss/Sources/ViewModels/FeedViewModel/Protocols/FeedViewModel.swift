//
//  FeedViewModel.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedViewModel {
    var cellHeightFullMode: CGFloat { get set }
    var cellHeightSimpleMode: CGFloat { get set }
    var titleHeight: CGFloat { get set }
    var descriptionHeight: CGFloat { get set }
    var source: String { get set }
    var newsTitleText: String { get set }
    var newsShortDescription: String { get set }
    var date: String { get set }
    var isFullMode: Bool { get set }
    var link: String { get set }
    var imgLink: String { get set }
    var img: UIImage? { get set }
    var isReaded: Bool { get set }
    var onImageUpdate: ((UIImage) -> Void)? { get set }
    func updateImgae(_ img: UIImage)
}
