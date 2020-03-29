//
//  SettingsModule.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//
//
//import UIKit
//
//final class SettingsAssembly {
//    
//   static func assemblySettingsModule() -> UIViewController {
//        let view = SettingsViewImpl()
//        let interactor = SettingsInteractorImpl()
//        let presenter = SettingsPresenterImpl()
//        let router = SettingsRouterImpl()
//        
//        view.presenter = presenter
//        
//        presenter.interactor = interactor
//        presenter.view = view
//        presenter.router = router
//        
//        interactor.presenter = presenter
//        
//        router.presenter = presenter
//        router.viewController = view
//        
//        return view
//    }
//}
