//
//  MainRouterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol MainRouterProtocol: class {
    var presenter: MainPresenterProtocol? { get set }
    
    func getViewControllers() -> [UIViewController]
}
