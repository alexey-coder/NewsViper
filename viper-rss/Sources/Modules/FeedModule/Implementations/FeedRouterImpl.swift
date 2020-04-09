//
//  FeedRouterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class FeedRouterImpl {
    weak var presenter: FeedPresenter?
    weak var viewController: UIViewController?
}

extension FeedRouterImpl: FeedRouter {
    func presentDetails(with url: String) {
        let detailsController = DetailsModuleAssembly.assemblyDetailsModule(url: url)
        viewController?.navigationController?.pushViewController(detailsController, animated: true)
    }
}
