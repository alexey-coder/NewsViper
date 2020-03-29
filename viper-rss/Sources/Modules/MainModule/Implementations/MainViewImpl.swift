//
//  MainViewImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class MainViewImpl: UITabBarController {
    var presenter: MainPresenterProtocol?
}

extension MainViewImpl: MainViewProtocol {
    func display(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
}
