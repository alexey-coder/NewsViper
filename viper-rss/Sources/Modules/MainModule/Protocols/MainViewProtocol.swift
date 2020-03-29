//
//  MainViewProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol MainViewProtocol: UIViewController {
    var presenter: MainPresenterProtocol? { get set }
    func display(_ viewControllers: [UIViewController])
}
