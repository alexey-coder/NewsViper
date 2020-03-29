//
//  MainPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class MainPresenterImpl {
    var router: MainRouterProtocol?
    var interactor: MainInteractorProtocol?
    var view: MainViewProtocol?
}

extension MainPresenterImpl: MainPresenterProtocol {
    
    func setupViewControllers() {
        guard let controllers = self.router?.getViewControllers() else {
            return
        }
        self.view?.display(controllers)
    }
}
