//
//  FeedInteractor.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol FeedInteractor {
    var presenter: FeedPresenter? { get set }
    func requestEntities(from sourses: [Sources])
    func update(entity: RSSEntity)
    func getAllModelsFromStore(with filter: Sources)
    func subscribeForUpdates()
}
