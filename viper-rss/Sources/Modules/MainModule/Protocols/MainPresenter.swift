//
//  MainPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol MainPresenter: class {
    
    var router: MainRouter { get set }
    var interactor: MainInteractor { get set }
    var view: MainView? { get set }
    
    func setupViewControllers()
    
}
