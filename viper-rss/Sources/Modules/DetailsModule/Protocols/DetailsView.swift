//
//  DetailsViewProtocol.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

protocol DetailsView: UIViewController {
    var presenter: DetailsPresenter { get set }
    func load(url: URL)
    func showAlert(with message: String)
}
