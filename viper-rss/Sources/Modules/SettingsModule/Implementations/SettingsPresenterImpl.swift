//
//  SettingsPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

private struct Metrics {
    struct Values {
        static let timerDefaultValue = Constants.DefaultValues.timerDefault
        static let sourceDefaultValue = Constants.DefaultValues.sourceDefault
        static let sources = Constants.DefaultValues.sources
        static let timers = Constants.DefaultValues.timers
    }
}

class SettingsPresenterImpl {
    var router: SettingsRouterProtocol?
    var interactor: SettingsInteractorProtocol?
    weak var view: SettingsViewProtocol?
    
    var heightForRow: CGFloat = 48
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    
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
                currentValue = String(describing: Metrics.Values.timerDefaultValue)
            }
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: currentValue)
        case .source:
            if let currentSource = userDefaultsStorage.savedSourceValue() {
                currentValue = currentSource
            } else {
                currentValue = Metrics.Values.sourceDefaultValue
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
            view?.showTimerPicker(with: Metrics.Values.timers, cellType: row)
        case .source:
            view?.showTimerPicker(with: Metrics.Values.sources, cellType: row)
        }
    }
}
