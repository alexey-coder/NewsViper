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
    func showDetails() {
        
    }
}
