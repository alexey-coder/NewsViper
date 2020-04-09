//
//  LayoutCalculator.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol LayoutCalculator {
    func mesureCellHeight(title: String, description: String, date: String) -> CellSizes
}
