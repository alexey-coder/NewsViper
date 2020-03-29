//
//  StartViewImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class StartViewImpl: UIViewController {
    var presenter: StartPresenterProtocol?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear()
    }
}

extension StartViewImpl: StartViewProtocol {
}
