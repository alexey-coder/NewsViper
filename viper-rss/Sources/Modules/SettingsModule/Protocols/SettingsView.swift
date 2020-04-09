//
//  SettingsViewProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol SettingsView: UIViewController {
    var presenter: SettingsPresenter { get set }
    func showTimerPicker<T>(with values: [T], cellType: SettingsHelper)
    func reloadData()
}
