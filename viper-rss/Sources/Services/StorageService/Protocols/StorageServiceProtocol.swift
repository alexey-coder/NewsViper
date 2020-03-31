//
//  StorageServiceProtocol.swift
//  viper-rss
//
//  Created by user on 30.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation

protocol StorageServiceProtocol: class {
    
}

protocol EventStorageServiceDelegate {
    // MARK: Event update lifecycle
    func eventStorageServiceWillUpdate(storageService: StorageServiceProtocol)
    func eventStorageServiceDidUpdate(storageService: StorageServiceProtocol)
    
    // MARK: Event section updates
    func eventStorageService(storageService: StorageServiceProtocol, shouldInsertSection section: IndexSet)
    func eventStorageService(storageService: StorageServiceProtocol, shouldDeleteSection section: IndexSet)
    func eventStorageService(storageService: StorageServiceProtocol, shouldUpdateSection section: IndexSet)
    func eventStorageService(storageService: StorageServiceProtocol, shouldMoveSectionFrom from: IndexSet, to: IndexSet)
    
    // MARK: Event row updates
    func eventStorageService(storageService: StorageServiceProtocol, shouldInsertRowAt row: IndexPath)
    func eventStorageService(storageService: StorageServiceProtocol, shouldDeleteRowAt row: IndexPath)
    func eventStorageService(storageService: StorageServiceProtocol, shouldUpdateRowAt row: IndexPath, withEvent event: Event)
    func eventStorageService(storageService: StorageServiceProtocol, shouldMoveRowFrom from: IndexPath, to: IndexPath, withEvent event: Event)
}
