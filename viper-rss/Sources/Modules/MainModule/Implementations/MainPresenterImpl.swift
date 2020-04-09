//
//  MainPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

final class MainPresenterImpl {
    var router: MainRouter
    var interactor: MainInteractor
    weak var view: MainView?
    
    init(router: MainRouter, interactor: MainInteractor) {
        self.router = router
        self.interactor = interactor
    }
}

extension MainPresenterImpl: MainPresenter {
    
    func setupViewControllers() {
        let controllers = router.getViewControllers()
        view?.display(controllers)
    }
}
