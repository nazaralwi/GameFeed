//
//  FavoriteProvider.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 17/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit
import CoreData

class FavoriteProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserFavorites")
        
        container.loadPersistentStores { storeDesription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllFavorites(completion: @escaping(_ members: [FavoriteModel]) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [FavoriteModel] = []
                for result in results {
                    let favorite = FavoriteModel(id: result.value(forKeyPath: "id") as? Int32,
                                                 name: result.value(forKeyPath: "name") as? String,
                                                 released: result.value(forKeyPath: "released") as? String,
                                                 rating: result.value(forKeyPath: "rating") as? Double,
                                                 backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                                                 genres: result.value(forKeyPath: "genres") as? String)
                    
                    favorites.append(favorite)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getFavorite(_ id: Int, completion: @escaping(_ members: FavoriteModel) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first{
                    let favorite =  FavoriteModel(id: result.value(forKeyPath: "id") as? Int32,
                                                  name: result.value(forKeyPath: "name") as? String,
                                                  released: result.value(forKeyPath: "released") as? String,
                                                  rating: result.value(forKeyPath: "rating") as? Double,
                                                  backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                                                  genres: result.value(forKeyPath: "genres") as? String)
                    completion(favorite)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
}
