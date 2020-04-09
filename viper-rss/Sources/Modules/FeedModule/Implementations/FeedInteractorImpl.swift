//
//  FeedInteractorImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

final class FeedInteractorImpl {
    weak var presenter: FeedPresenter?
    
    private let rssParser: RSSParserService
    private let storageService: StorageService
    let dispatchGroup = DispatchGroup()
    
    init(
        rssParser: RSSParserService,
        storageService: StorageService) {
        self.rssParser = rssParser
        self.storageService = storageService
    }
}

extension FeedInteractorImpl: FeedInteractor {
    
    func update(entity: RSSEntity) {
        storageService.update(entity: entity)
    }
    
    func getAllModelsFromStore(with filter: Sources) {
        storageService.listFromStorage(with: filter) { result in
            switch result {
            case .success(let entities):
                self.presenter?.createViewModelsFromScratch(with: entities)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func subscribeForUpdates() {
        storageService.subscribe { [weak self] entity in
            self?.presenter?.createNewViewModel(with: entity)
        }
    }
    
    func requestEntities(from sourses: [Sources]) {
        var entities = [RSSEntity]()
        sourses.forEach { source in
            rssParser.parseFeed(
                url: source.getLink(),
                successCompletion: { entity in
                    var updatedEntity = entity
                    updatedEntity.source = source.description
                    entities.append(updatedEntity)
            }, errorCompletion: { error in
                self.presenter?.showAlert(message: error.localizedDescription)
            })
        }
        entities.forEach {
            storageService.save(entity: $0)
        }
    }
}
