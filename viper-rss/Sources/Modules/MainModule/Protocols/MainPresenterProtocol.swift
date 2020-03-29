//
//  MainPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol MainPresenterProtocol: class {
    
    var router: MainRouterProtocol? { get set }
    var interactor: MainInteractorProtocol? { get set }
    var view: MainViewProtocol? { get set }
    
    func setupViewControllers()
    
}
