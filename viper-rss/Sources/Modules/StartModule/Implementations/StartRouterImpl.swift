//
//  StartRouterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class StartRouterImpl {
    weak var presenter: StartPresenterProtocol?
    weak var viewController: UIViewController?
}

extension StartRouterImpl: StartRouterProtocol {
    func showMain() {
        let mainViewController = ModuleDependencyContainer().assemblyMainModule()
        mainViewController.modalPresentationStyle = .overFullScreen
        self.viewController?.present(mainViewController, animated: true, completion: nil)
    }
}
