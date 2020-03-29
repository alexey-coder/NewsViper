//
//  SettingsPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol SettingsPresenterProtocol: class {
    var router: SettingsRouterProtocol? { get set }
    var interactor: SettingsInteractorProtocol? { get set }
    var view: SettingsViewProtocol? { get set }
    
    var heightForRow: CGFloat { get set }
    func getNumberOfRows() -> Int
    func getViewModel(by indexPath: IndexPath) -> SettingsTimerViewModelProtocol?
    func didRowSelected(_ row: Int)
}
