//
//  SettingsTimerCellImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Fonts {
        static let settingCellLabelFont = FontHelper.Bold.of(size: 18)
    }
    
    struct Colors {
        static let settingCellLabelColor = ColorHelper.settingsLabelColor
        static let backgroundColor = ColorHelper.baseBackgroundColor
    }
}

class SettingsTimerCellImpl: UITableViewCell, SettingsCellProtocol {
    
    let settingCellLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = Metrics.Fonts.settingCellLabelFont
        $0.textColor = Metrics.Colors.settingCellLabelColor
    }
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Metrics.Colors.backgroundColor
        addSubview(settingCellLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SettingsTimerViewModelProtocol) {
        settingCellLabel.text = viewModel.labelText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        settingCellLabel.frame = CGRect(
            x: 24,
            y: (self.frame.height / 2) - (settingCellLabel.intrinsicContentSize.height / 2),
            width: settingCellLabel.intrinsicContentSize.width,
            height: settingCellLabel.intrinsicContentSize.height)
    }
}
