//
//  DetailsPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol DetailsPresenterProtocol: class {
    var router: DetailsRouterProtocol? { get set }
    var interactor: DetailsInteractorProtocol? { get set }
    var view: DetailsViewProtocol? { get set }
    
    func viewDidLoad()
}
