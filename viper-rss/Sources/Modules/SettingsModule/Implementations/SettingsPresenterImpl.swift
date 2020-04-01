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
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
    }
}

extension SettingsPresenterImpl: SettingsPresenterProtocol {
    func setNewTimer(interval: Date) {
        print("\(interval)")
//        userDefaultsStorage.saveTimerValue(with: interval)
    }
    
    func getNumberOfRows() -> Int {
        return SettingsHelper.getNumRows()
    }
    
    func getViewModel(by indexPath: IndexPath) -> SettingsTimerViewModelProtocol? {
        guard let row = SettingsHelper(rawValue: indexPath.row) else {
            return nil
        }
        switch row {
        case .timer:
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: "blaBla")
        case .category:
            return SettingsViewModelImpl(labelText: row.getTitle(), currentValue: "lala")
        }
    }
    
    func didRowSelected(_ row: Int) {
        guard let row = SettingsHelper(rawValue: row) else {
            return
        }
        switch row {
        case .timer:
            view?.showTimerPicker()
        case .category:
            return
        }
    }
}
