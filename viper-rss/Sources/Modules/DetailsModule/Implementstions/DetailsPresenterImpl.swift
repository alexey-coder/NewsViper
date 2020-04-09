//
//  DetailsPresenterImpl.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class DetailsPresenterImpl {
    var router: DetailsRouter
    var interactor: DetailsInteractor
    weak var view: DetailsView?
    
    let url: String
    
    init(
        router: DetailsRouter,
        interactor: DetailsInteractor,
        url: String) {
        self.router = router
        self.interactor = interactor
        self.url = url
    }
}

extension DetailsPresenterImpl: DetailsPresenter {
    func viewDidLoad() {
        guard let url = URL(string: url) else {
            view?.showAlert(with: "Ooops!💩")
            return
        }
        view?.load(url: url)
    }
}
