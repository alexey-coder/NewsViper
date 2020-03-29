//
//  StartPresenterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class StartPresenterImpl {
    var router: StartRouterProtocol?
    var interactor: StartInteractorProtocol?
    weak var view: StartViewProtocol?
}

extension StartPresenterImpl: StartPresenterProtocol {
    func viewDidAppear() {
        self.router?.showMain()
    }
}
