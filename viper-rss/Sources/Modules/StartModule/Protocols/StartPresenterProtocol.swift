//
//  StartPresenterProtocol.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol StartPresenterProtocol: class {
    var router: StartRouterProtocol? { get set }
    var interactor: StartInteractorProtocol? { get set }
    var view: StartViewProtocol? { get set }
    
    func viewDidAppear()
}
