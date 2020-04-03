//
//  FeedInteractorImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

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
    
    func saveInStorage(entity: RSSEntity) {
        storageService.save(entity: entity)
    }
    
    func requestEntities(from sourses: [Sources]) {
        sourses.forEach { source in
            let parser = RSSParserServiceImpl()
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
