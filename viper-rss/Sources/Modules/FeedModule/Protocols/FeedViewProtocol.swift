//
//  FeedView.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol FeedViewProtocol: UIViewController {
    var presenter: FeedPresenterProtocol? { get set }
    func reloadData()
    func showAlert(with message: String)
}
