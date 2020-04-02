//
//  SettingsPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class SettingsPresenterImpl {
    var router: SettingsRouterProtocol?
    var interactor: SettingsInteractorProtocol?
    weak var view: SettingsViewProtocol?
    
    var heightForRow: CGFloat = 48
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    private let timers = [15, 30, 60]
    private let categories = ["val1", "val2"]
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
    }
}

extension SettingsPresenterImpl: SettingsPresenterProtocol {
    func setNewTimer(interval: Int) {
        userDefaultsStorage.saveTimerValue(with: interval)
        view?.reloadData()
    }
    
    func setNewCategory(filter: String) {
        userDefaultsStorage.saveSourceValue(with: filter)
        view?.reloadData()
    }
    
    func getNumberOfRows() -> Int {
        return SettingsHelper.getNumRows()
    }
    
    func getViewModel(by indexPath: IndexPath) -> SettingsTimerViewModelProtocol? {
        guard let row = SettingsHelper(rawValue: indexPath.row) else {
            return nil
        }
        let currentValue: String
        switch row {
        case .timer:
            if let currentTimerValue = userDefaultsStorage.savedTimerValue() {
                currentValue = String(describing: currentTimerValue)
            } else {
                currentValue = "5"
            }
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: currentValue)
        case .category:
            if let currentCategory = userDefaultsStorage.savedSourceValue() {
                currentValue = currentCategory
            } else {
                currentValue = "val1"
            }
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: currentValue)
        }
    }
    
    func didRowSelected(_ row: Int) {
        guard let row = SettingsHelper(rawValue: row) else {
            return
        }
        switch row {
        case .timer:
            view?.showTimerPicker(with: timers, cellType: row)
        case .category:
            view?.showTimerPicker(with: categories, cellType: row)
        }
    }
}
