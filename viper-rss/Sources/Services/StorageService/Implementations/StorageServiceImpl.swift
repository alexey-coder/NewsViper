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
    private var onDidInsert: ((RSSEntity) -> Void)?
    
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
        persistentContainer.performBackgroundTask { context in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "XMLEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", entity.postId)
            let res = try! context.fetch(fetchRequest)
            if !res.isEmpty {
                return
            }
            if let newEntity = NSEntityDescription.entity(forEntityName: "XMLEntity", in: context) {
                let xmlEntity = XMLEntity(entity: newEntity, insertInto: context)
                xmlEntity.id = entity.postId
                xmlEntity.title = entity.title
                xmlEntity.text = entity.description
                xmlEntity.link = entity.link
                xmlEntity.imgUrl = entity.imgUrl
                xmlEntity.date = entity.pubdate
                xmlEntity.source = entity.source
                do {
                    try context.save()
                } catch {
                    print("\(error)")
                }
            }
        }
    }
    
    func update(entity: RSSEntity) {
        persistentContainer.performBackgroundTask { context in
            let fetchRequest = NSFetchRequest<XMLEntity>(entityName: "XMLEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", entity.postId)
            do {
                let res = try context.fetch(fetchRequest)
                if res.isEmpty {
                    return
                }
                res.first?.setValue(true, forKey: "isReaded")
                try context.save()
            } catch {
                print("\(error)")
            }
        }
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
    
    func subscribe(onInsert: @escaping ((RSSEntity) -> Void)) {
        self.onDidInsert = onInsert
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
            onDidInsert?(xmlEntity.toSwiftModel())
        }
    }
}
