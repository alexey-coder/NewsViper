//
//  FeedInteractorImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation //remove this

class FeedInteractorImpl {
    weak var presenter: FeedPresenterProtocol?
    
    private let rssParser: RSSParserServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(
        rssParser: RSSParserServiceProtocol,
        storageService: StorageServiceProtocol) {
        self.rssParser = rssParser
        self.storageService = storageService
    }
}

extension FeedInteractorImpl: FeedInteractorProtocol {
    func getAllModelsFromStore() {
        let entities = self.storageService.listFromStorage()
        self.presenter?.present(entities: entities)
    }
    
    func subscribeForUpdates() {
        storageService.subscribe { [weak self] entity in
            guard let self = self else {
                return
            }
            self.presenter?.present(entities: [entity])
        }
    }
    
    func saveInStorage(entity: RSSEntity) {
        storageService.save(entity: entity)
    }
    
    func requestEntities(from sourses: [Sources]) {
        sourses.forEach { source in
            let parser = RSSParserServiceImpl() // TODO!
            parser.parseFeed(
                url: source.getLink(),
                successCompletion: { [weak self] entity in
                    var updatedEntity = entity
                    updatedEntity.source = source.description
                    self?.presenter?.store(entity: updatedEntity)
                }, errorCompletion: { error in
                    self.presenter?.showAlert(message: error.localizedDescription)
            })
        }
    }
}
