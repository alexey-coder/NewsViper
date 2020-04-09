//
//  FeedCellProtocol.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedCell: UITableViewCell, ReusableCell {
    func configure(with viewModel: FeedViewModel)
}
