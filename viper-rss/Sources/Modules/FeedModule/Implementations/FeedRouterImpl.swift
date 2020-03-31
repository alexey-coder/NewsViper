//
//  FeedRouterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class FeedRouterImpl {
    weak var presenter: FeedPresenterProtocol?
    weak var viewController: UIViewController?
}

extension FeedRouterImpl: FeedRouterProtocol {
    func presentDetails(with url: String) {
        let detailsController = ModuleDependencyContainer().assemblyDetailModule(with: url)
        viewController?.navigationController?.pushViewController(detailsController, animated: true)
    }
}
