//
//  SettingsViewProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol SettingsViewProtocol: UIViewController {
    var presenter: SettingsPresenterProtocol? { get set }
    func showTimerPicker()
}
