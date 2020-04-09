//
//  MainInteractorProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol MainInteractor {
    var presenter: MainPresenter? { get set }
}
