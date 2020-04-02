//
//  FeedInteractor.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol FeedInteractorProtocol {
    var presenter: FeedPresenterProtocol? { get set }
    func requestEntities(from sourses: [Sources])
    func saveInStorage(entity: RSSEntity)
    func update(entity: RSSEntity)
    func getAllModelsFromStore()
    func subscribeForUpdates()
}
