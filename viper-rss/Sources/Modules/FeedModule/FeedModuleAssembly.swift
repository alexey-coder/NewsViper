//
//  FeedModuleAssembly.swift
//  viper-rss
//
//  Created by user on 08.04.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

final class FeedModuleAseembly {
    static func assemblyFeedModule() -> FeedView {
        let interactor = FeedInteractorImpl(
            rssParser: RSSParserServiceImpl(),
            storageService: StorageServiceImpl())
        let router = FeedRouterImpl()
        let presenter = FeedPresenterImpl(
            router: router,
            interactor: interactor,
            viewModelHelper: FeedViewModelHelperImpl(
                feedCellLayoutCalculator: FeedCellLayoutCalculatorImpl(),
                imageLoaderService: ImageDownloadServiceImpl()),
                userDefaultsStorage: UserDefaultsStorageImpl(),
                timerWorker: TimerWorkerImpl(userDefaultsStorage: UserDefaultsStorageImpl()))
        let view = FeedViewImpl(
            presenter: presenter,
            alertService: AlertServiceImpl())
        presenter.view = view
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view
        return view
    }
}
