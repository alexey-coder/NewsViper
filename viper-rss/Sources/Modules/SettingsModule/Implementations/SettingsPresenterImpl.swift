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
    
    lazy var timerTapped: (() -> Void) = {
        print("bla")
    }
    
    lazy var categoryTapped: (() -> Void) = {
        print("lalal")
    }
    
    var heightForRow: CGFloat = 48
}

extension SettingsPresenterImpl: SettingsPresenterProtocol {
    
    func getNumberOfRows() -> Int {
        return SettingsHelper.getNumRows()
    }
    
    func getViewModel(by indexPath: IndexPath) -> SettingsTimerViewModelProtocol? {
        guard let row = SettingsHelper(rawValue: indexPath.row) else {
            return nil
        }
        switch row {
        case .timer:
            return SettingsViewModelImpl(labelText: row.getTitle())
        case .category:
            return SettingsViewModelImpl(labelText: row.getTitle())
        }
    }
    
    func didRowSelected(_ row: Int) {
        guard let row = SettingsHelper(rawValue: row) else {
            return
        }
        switch row {
        case .timer:
            timerTapped()
        case .category:
            categoryTapped()
        }
    }
}
