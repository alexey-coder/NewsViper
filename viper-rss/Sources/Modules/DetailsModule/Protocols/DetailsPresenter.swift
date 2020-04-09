//
//  DetailsPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol DetailsPresenter: class {
    var router: DetailsRouter { get set }
    var interactor: DetailsInteractor { get set }
    var view: DetailsView? { get set }
    
    func viewDidLoad()
}
