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
    
    static let shared = StorageServiceImpl()
    private var onDidUpdate: ((RSSEntity) -> Void)?
    
    private override init() {}
    private let moduleName = "viper_rss"
    private lazy var managedObjectContext = persistentContainer.viewContext
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: moduleName)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func save(entity: RSSEntity) {
        if isExist(id: entity.postId) {
            return
        }
        
        if let newEntity = NSEntityDescription.entity(forEntityName: "XMLEntity", in: managedObjectContext) {
            let xmlEntity = XMLEntity(entity: newEntity, insertInto: managedObjectContext)
            xmlEntity.id = entity.postId
            xmlEntity.title = entity.title
            xmlEntity.text = entity.description
            xmlEntity.link = entity.link
            xmlEntity.imgUrl = entity.imgUrl
            xmlEntity.date = entity.pubdate
            xmlEntity.source = entity.source
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func isExist(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "XMLEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let res = try! managedObjectContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<XMLEntity> = {
        let fetchRequest = NSFetchRequest<XMLEntity>(entityName: "XMLEntity")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController<XMLEntity>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    func subscribe(onUpdate: @escaping ((RSSEntity) -> Void)) {
        self.onDidUpdate = onUpdate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func listFromStorage() -> [RSSEntity] {
      do {
        try fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects!.map {
            $0.toSwiftModel()
        }
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
}

extension StorageServiceImpl: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            guard let xmlEntity = anObject as? XMLEntity else {
                return
            }
            onDidUpdate?(xmlEntity.toSwiftModel())
        }
    }
}
