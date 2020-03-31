//
//  FeedInteractorImpl.swift
//  viper-rss
//
//  Created by user on 25.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import UIKit //remove this

class FeedInteractorImpl {
    weak var presenter: FeedPresenterProtocol?
    
    private let rssParser: RSSParserServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(rssParser: RSSParserServiceProtocol,
         storageService: StorageServiceProtocol) {
        self.rssParser = rssParser
        self.storageService = storageService
    }
}

extension FeedInteractorImpl: FeedInteractorProtocol {
    func subscribeForUpdates() {
        if let store = storageService as? StorageServiceImpl {
            store.delegates.append(self)
        }
    }
    
    func unsubscribeFromUpdates() {
        //        if let store = storageService as? StorageServiceImpl {
        //            if let index = store.delegates.first(where: { $0 === self }) {
        //                store.delegates.remove(at: index)
        //            }
        //        }
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
                    self?.presenter?.store(entity: entity, from: source.description)
                }, errorCompletion: { error in
                    self.presenter?.showAlert(message: error.localizedDescription)
            })
        }
    }
}

extension FeedInteractorImpl: EventStorageServiceDelegate {
    func eventStorageServiceWillUpdate(storageService: StorageServiceProtocol) {
        presenter?.startEventUpdates()
    }
    
    func eventStorageServiceDidUpdate(storageService: StorageServiceProtocol) {
        presenter?.stopEventUpdates()
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldInsertSection section: IndexSet) {
        presenter?.presentInsertedSection(section: section)
        
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldDeleteSection section: IndexSet) {
        presenter?.presentDeletedSection(section: section)
        
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldUpdateSection section: IndexSet) {
        presenter?.presentUpdatedSection(section: section)
        
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldMoveSectionFrom from: IndexSet, to: IndexSet) {
        presenter?.presentMovedSection(from: from, to: to)
        
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldInsertRowAt row: IndexPath) {
        presenter?.presentInsertedRowAt(row: row)
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldDeleteRowAt row: IndexPath) {
        presenter?.presentDeletedRowAt(row: row)
        
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldUpdateRowAt row: IndexPath, withEvent event: RSSEntity) {
        presenter?.presentUpdatedRowAt(row: row, withEvent: event)
        
    }
    
    func eventStorageService(storageService: StorageServiceProtocol, shouldMoveRowFrom from: IndexPath, to: IndexPath, withEvent event: RSSEntity) {
        presenter?.presentMovedRow(from: from, to: to, withEvent: event)
    }
}
