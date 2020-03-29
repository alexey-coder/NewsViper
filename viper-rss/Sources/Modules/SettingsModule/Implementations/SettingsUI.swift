//
//  SettingsUI.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Colors {
        static let backgroundColor = ColorHelper.baseBackgroundColor
    }
}

class SettingsUI: UIView {
    
    var tableView = UITableView().then {
        $0.register(SettingsTimerCellImpl.self, forCellReuseIdentifier: SettingsTimerCellImpl.reuseIdentifier)
        $0.register(SettingsCategoryCellImpl.self, forCellReuseIdentifier: SettingsCategoryCellImpl.reuseIdentifier)
        $0.backgroundColor = Metrics.Colors.backgroundColor
        $0.isScrollEnabled = false
        $0.tableFooterView = UIView(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Metrics.Colors.backgroundColor
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
