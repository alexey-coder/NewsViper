//
//  DependencyContainer.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

class ModuleDependencyContainer {
    private lazy var alertService = AlertServiceImpl()
    private lazy var rssParser = RSSParserServiceImpl()
    private lazy var feedCellLayoutCalculator = FeedCellLayoutCalculatorImpl()
    private lazy var storageService = StorageServiceImpl.shared
    private lazy var userDefaultsStorage = UserDefaultsStorageImpl()
    private lazy var timerWorker = TimerWorkerImpl(userDefaultsStorage: userDefaultsStorage)
    private lazy var imageLoader = ImageDownloadServiceImpl()
    private lazy var feedViewModelHelper = FeedViewModelHelperImpl(
        feedCellLayoutCalculator: feedCellLayoutCalculator, imageLoaderService: imageLoader)
}

extension ModuleDependencyContainer: ModuleFactoryProtocol {
    func assemblyDetailModule(with url: String) -> DetailsViewProtocol {
        let view = DetailsViewImpl(alertService: alertService)
        let interactor = DetailsInteractorImpl()
        let presenter = DetailsPresenterImpl(url: url)
        let router = DetailsRouterImpl()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
    
    func assemblyFeedModule() -> FeedViewProtocol {
        let view = FeedViewImpl(alertService: alertService)
        let interactor = FeedInteractorImpl(
            rssParser: rssParser, storageService: storageService)
        let presenter = FeedPresenterImpl(
            viewModelHelper: feedViewModelHelper,
            userDefaultsStorage: userDefaultsStorage,
            timerWorker: timerWorker)
        let router = FeedRouterImpl()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
    
    func assemblySettingsModule() -> SettingsViewProtocol {
        let view = SettingsViewImpl(alertService: alertService)
        let interactor = SettingsInteractorImpl()
        let presenter = SettingsPresenterImpl(userDefaultsStorage: userDefaultsStorage)
        let router = SettingsRouterImpl()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
    
    func assemblyMainModule() -> MainViewProtocol {
        let view = MainViewImpl()
        let interactor = MainInteractorImpl()
        let presenter = MainPresenterImpl()
        let router = MainRouterImpl()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        presenter.setupViewControllers()
        return view
    }
    
    func buildStartModule() -> StartViewProtocol {
        let view = StartViewImpl()
        let interactor = StartInteractorImpl()
        let presenter = StartPresenterImpl()
        let router = StartRouterImpl()
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
}
