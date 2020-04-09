//
//  SettingsPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol SettingsPresenter: class {
    var router: SettingsRouter { get set }
    var interactor: SettingsInteractor { get set }
    var view: SettingsView? { get set }
    
    var heightForRow: CGFloat { get set }
    func getNumberOfRows() -> Int
    func getViewModel(by indexPath: IndexPath) -> SettingsTimerViewModel?
    func didRowSelected(_ row: Int)
    func setNewTimer(interval: Int)
    func setNewCategory(filter: String)
}
