//
//  ModuleFactoryProtocol.swift
//  viper-rss
//
//  Created by user on 29.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol ModuleFactoryProtocol {
    func assemblyDetailModule(with url: String) -> DetailsViewProtocol
    func assemblyFeedModule() -> FeedViewProtocol
    func assemblySettingsModule() -> SettingsViewProtocol
    func assemblyMainModule() -> MainViewProtocol
    func buildStartModule() -> StartViewProtocol
}
