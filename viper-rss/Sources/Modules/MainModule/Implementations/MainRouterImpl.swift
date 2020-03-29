//
//  MainRouterImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit

class MainRouterImpl {
    weak var presenter: MainPresenterProtocol?
    weak var viewController: UIViewController?
}

extension MainRouterImpl: MainRouterProtocol {
    func getViewControllers() -> [UIViewController] {
        let feed: UIViewController = ModuleDependencyContainer().assemblyFeedModule()
        let settings: UIViewController = ModuleDependencyContainer().assemblySettingsModule()
        feed.tabBarItem = UITabBarItem(
            title: LocalizedImpl<MainModuleLocalizedKeys>(.feed).text,
            image: AssetsHelper.tabBarIcons.catalogTabbar.image,
            selectedImage: AssetsHelper.tabBarIconsActive.catalogTabbarActive.image)
        settings.tabBarItem = UITabBarItem(
            title: LocalizedImpl<MainModuleLocalizedKeys>(.settings).text,
            image: AssetsHelper.tabBarIcons.menuTabbar.image,
            selectedImage: AssetsHelper.tabBarIconsActive.menuTabbarActive.image)
        return [feed, settings].map { UINavigationController(rootViewController: $0) }
    }
}
