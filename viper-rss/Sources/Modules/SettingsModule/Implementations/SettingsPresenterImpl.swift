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
    private let viewModelFactory: SettingsViewModelFactoryProtocol
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
        self.viewModelFactory = SettingsViewModelFactory(userDefaultsStorage: userDefaultsStorage)
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
        return viewModelFactory.produceViewModel(by: indexPath)
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
