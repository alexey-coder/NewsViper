//
//  DetailsPresenterImpl.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class DetailsPresenterImpl {
    var router: DetailsRouterProtocol?
    var interactor: DetailsInteractorProtocol?
    weak var view: DetailsViewProtocol?
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
}

extension DetailsPresenterImpl: DetailsPresenterProtocol {
    func viewDidLoad() {
        guard let url = URL(string: url) else {
            view?.showAlert(with: "Ooops!💩")
            return
        }
        view?.load(url: url)
    }
}
