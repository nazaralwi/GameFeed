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
                    let favorite = FavoriteModel(id: result.value(forKeyPath: "id") as? Int64,
                                                 name: result.value(forKeyPath: "name") as? String,
                                                 released: result.value(forKeyPath: "released") as? String,
                                                 rating: result.value(forKeyPath: "rating") as? String,
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
                    let favorite =  FavoriteModel(id: result.value(forKeyPath: "id") as? Int64,
                                                  name: result.value(forKeyPath: "name") as? String,
                                                  released: result.value(forKeyPath: "released") as? String,
                                                  rating: result.value(forKeyPath: "rating") as? String,
                                                  backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                                                  genres: result.value(forKeyPath: "genres") as? String)
                    completion(favorite)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addToFavorite(_ id: Int, _ name: String, _ released: String, _ rating: String, _ genres: String, completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                let favorite = NSManagedObject(entity: entity, insertInto: taskContext)
                
                favorite.setValue(id, forKey: "id")
                favorite.setValue(name, forKey: "name")
                favorite.setValue(rating, forKey: "rating")
                favorite.setValue(released, forKey: "released")
//                favorite.setValue(backgroundPath, forKey: "backgroundImage")
                favorite.setValue(genres, forKey: "genres")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
//    func getMaxId(completion: @escaping(_ maxId: Int) -> ()) {
//        let taskContext = newTaskContext()
//        taskContext.performAndWait {
//            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
//            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
//            fetchRequest.sortDescriptors = [sortDescriptor]
//            fetchRequest.fetchLimit = 1
//            do {
//                let lastMember = try taskContext.fetch(fetchRequest)
//                if let member = lastMember.first, let position = member.value(forKeyPath: "id") as? Int{
//                    completion(position)
//                } else {
//                    completion(0)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func deleteAllFavorite(completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
    
    func deleteFavorite(_ id: Int, completion: @escaping() -> ()){
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}
