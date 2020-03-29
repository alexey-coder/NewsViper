//
//  FontHelper.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

enum FontHelper: String {
    
    case Regular = "Roboto-Regular"
    case Medium  = "Roboto-Medium"
    case Bold    = "Roboto-Bold"
    
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: size)
    }
}
