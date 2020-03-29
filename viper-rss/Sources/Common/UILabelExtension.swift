//
//  UILabelExtension.swift
//  viper-rss
//
//  Created by user on 28.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

extension UILabel {
    public func mesureHeight(with limit: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: limit))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}


//extension UILabel {
//    public var requiredHeight: CGFloat {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: .greatestFiniteMagnitude))
//        label.numberOfLines = numberOfLines
//        label.lineBreakMode = .byWordWrapping
//        label.font = font
//        label.text = text
//        label.attributedText = attributedText
//        label.sizeToFit()
//        return label.frame.height
//    }
//}
