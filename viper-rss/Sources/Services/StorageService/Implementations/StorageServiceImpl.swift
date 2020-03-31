//
//  StorageServiceImpl.swift
//  viper-rss
//
//  Created by user on 30.03.2020.
//  Copyright © 2020 smirnov. All rights reserved.
//

import Foundation
import CoreData

final class StorageServiceImpl: NSObject, StorageServiceProtocol {
   
    var delegates = [EventStorageServiceDelegate]()
    
    static let shared = StorageServiceImpl()
    
    private override init() {}
    
    lazy var persistentContainer = NSPersistentContainer(name: "viper_rss").then {
        $0.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var _fetchedResultsController: NSFetchedResultsController<XMLEntity>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<XMLEntity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<XMLEntity> = XMLEntity.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        _fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: "XMLEntity")
        _fetchedResultsController!.delegate = self
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    
    func save(entity: RSSEntity) {
        if let newEntity = NSEntityDescription.entity(forEntityName: "XMLEntity", in: managedObjectContext) {
            let xmlEntity = XMLEntity(entity: newEntity, insertInto: managedObjectContext)
            xmlEntity.id = entity.postId
            xmlEntity.title = entity.title
            xmlEntity.text = entity.description
            xmlEntity.link = entity.link
            xmlEntity.imgUrl = entity.imgUrl
            xmlEntity.date = entity.pubdate
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
    }
}

extension StorageServiceImpl: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegates.forEach {
            $0.eventStorageServiceWillUpdate(storageService: self)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            delegates.forEach {
                $0.eventStorageService(storageService: self, shouldInsertSection: IndexSet(integer: sectionIndex))
            }
        case .delete:
            delegates.forEach {
                $0.eventStorageService(storageService: self, shouldDeleteSection: IndexSet(integer: sectionIndex))
            }
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            delegates.forEach {
                $0.eventStorageService(storageService: self, shouldInsertRowAt: newIndexPath!)
            }
        case .delete:
            delegates.forEach {
                $0.eventStorageService(storageService: self, shouldDeleteRowAt: indexPath!)
            }
        case .update:
            let event = anObject as! RSSEntity
            delegates.forEach {
                $0.eventStorageService(storageService: self, shouldUpdateRowAt: indexPath!, withEvent: event)
            }
        case .move:
            let event = anObject as! RSSEntity
            delegates.forEach {
                $0.eventStorageService(storageService: self, shouldMoveRowFrom: indexPath!, to: newIndexPath!, withEvent: event)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegates.forEach {
            $0.eventStorageServiceDidUpdate(storageService: self)
        }
    }
}
