//
//  SettingsCategoryCellImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Fonts {
        static let settingCellLabelFont = FontHelper.Bold.of(size: 18)
        static let currentValueCellLabelFont = FontHelper.Bold.of(size: 14)
    }
    
    struct Colors {
        static let settingCellLabelColor = ColorHelper.settingsLabelColor
        static let backgroundColor = ColorHelper.baseBackgroundColor
        static let currentValueColor = Constants.Colors.settingsSecondaryColor
    }
}

class SettingsCategoryCellImpl: UITableViewCell, SettingsCellProtocol {
    
    let settingCellLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = Metrics.Fonts.settingCellLabelFont
        $0.textColor = Metrics.Colors.settingCellLabelColor
    }
    
    let currentValueLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = Metrics.Fonts.currentValueCellLabelFont
        $0.textColor = Metrics.Colors.currentValueColor
    }
       
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Metrics.Colors.backgroundColor
        [currentValueLabel, settingCellLabel].forEach { addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SettingsTimerViewModelProtocol) {
        settingCellLabel.text = viewModel.labelText
        currentValueLabel.text = viewModel.currentValue
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        settingCellLabel.frame = CGRect(
            x: 24,
            y: (self.frame.height / 2) - (settingCellLabel.intrinsicContentSize.height / 2),
            width: settingCellLabel.intrinsicContentSize.width,
            height: settingCellLabel.intrinsicContentSize.height)
        
        currentValueLabel.frame = CGRect(
            x: frame.width - 24 - currentValueLabel.intrinsicContentSize.width,
            y: (self.frame.height / 2) - (currentValueLabel.intrinsicContentSize.height / 2),
            width: currentValueLabel.intrinsicContentSize.width,
            height: currentValueLabel.intrinsicContentSize.height)
    }
}
