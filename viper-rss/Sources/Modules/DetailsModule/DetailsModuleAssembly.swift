//
//  DetailsModuleAssembly.swift
//  viper-rss
//
//  Created by user on 08.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class DetailsModuleAssembly {
    static func assemblyDetailsModule(url: String) -> DetailsView {
        let interactor = DetailsInteractorImpl()
        let router = DetailsRouterImpl()
        let presenter = DetailsPresenterImpl(
            router: router,
            interactor: interactor,
            url: url)
        let view = DetailsViewImpl(
            presenter: presenter,
            alertService: AlertServiceImpl())
        presenter.view = view
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
}
