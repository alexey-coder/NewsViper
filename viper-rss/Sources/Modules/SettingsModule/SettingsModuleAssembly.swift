//
//  SettingsAssembly.swift
//  viper-rss
//
//  Created by user on 08.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class SettingsModuleAssembly {
    static func assemblySettingsModule() -> SettingsView {
        let interactor = SettingsInteractorImpl()
        let router = SettingsRouterImpl()
        let presenter = SettingsPresenterImpl(
            router: router,
            interactor: interactor,
            userDefaultsStorage: UserDefaultsStorageImpl())
        let view = SettingsViewImpl(
            presenter: presenter,
            alertService: AlertServiceImpl())
        presenter.view = view
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
}
