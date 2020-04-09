//
//  MainModuleAssembly.swift
//  viper-rss
//
//  Created by user on 08.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class MainModuleAssembly {
    static func assemblyMainModule() -> MainView {
        let interactor = MainInteractorImpl()
        let router = MainRouterImpl()
        let presenter = MainPresenterImpl(router: router, interactor: interactor)
        let view = MainViewImpl(presenter: presenter)
        presenter.view = view
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        presenter.setupViewControllers()
        return view
    }
}
