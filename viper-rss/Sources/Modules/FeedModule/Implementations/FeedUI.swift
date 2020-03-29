//
//  FeedUI.swift
//  viper-rss
//
//  Created by user on 27.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Colors {
        static let backgroundColor = ColorHelper.baseBackgroundColor
    }
}

class FeedUI: UIView {
    
    let segmentControl = UISegmentedControl().then {
        $0.tintColor = .black
    }
    
    let tableView = UITableView().then {
        $0.register(FeedCellImpl.self, forCellReuseIdentifier: FeedCellImpl.reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Metrics.Colors.backgroundColor
        [tableView, segmentControl].forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
