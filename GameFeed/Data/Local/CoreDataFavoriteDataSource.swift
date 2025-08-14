import UIKit
import CoreData
import Combine

public protocol CoreDataFavoriteDataSourceProtocol {
    func getAllFavorites() -> Future<[GameModel], Error>
    func getFavorite(_ id: Int) -> Future<GameModel, Error>
    func addToFavorite(game: GameModel, _ isFavorite: Bool) -> Future<Void, Error>
    func deleteAllFavorite() -> Future<Void, Error>
    func checkData(id: Int) -> Bool
    func deleteFavorite(_ id: Int) -> Future<Void, Error>
}

public final class CoreDataFavoriteDataSource: CoreDataFavoriteDataSourceProtocol {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserFavorites")

        container.loadPersistentStores { _, error in
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

    public func getAllFavorites() -> Future<[GameModel], Error> {
        return Future { promise in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var favorites: [FavoriteModel] = []
                    for result in results {
                        let favorite = FavoriteModel(
                            id: result.value(forKeyPath: "id") as? Int64,
                            name: result.value(forKeyPath: "name") as? String,
                            released: result.value(forKeyPath: "released") as? String,
                            rating: result.value(forKeyPath: "rating") as? String,
                            backgroundImagePath: result.value(forKeyPath: "backgroundImage") as? String,
                            genres: result.value(forKeyPath: "genres") as? String)

                        favorites.append(favorite)
                    }
                    promise(.success(favorites.map { GameMapper.mapGameFavoriteModelToGameModel(game: $0) }))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

    public func getFavorite(_ id: Int) -> Future<GameModel, Error> {
        return Future { promise in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                do {
                    if let result = try taskContext.fetch(fetchRequest).first {
                        let favorite =  FavoriteModel(
                            id: result.value(forKeyPath: "id") as? Int64,
                            name: result.value(forKeyPath: "name") as? String,
                            released: result.value(forKeyPath: "released") as? String,
                            rating: result.value(forKeyPath: "rating") as? String,
                            backgroundImagePath: result.value(forKeyPath: "backgroundImage") as? String,
                            genres: result.value(forKeyPath: "genres") as? String)
                        promise(.success(GameMapper.mapGameFavoriteModelToGameModel(game: favorite)))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }

    public func addToFavorite(game: GameModel, _ isFavorite: Bool) -> Future<Void, Error> {
        return Future { promise in
            let taskContext = self.newTaskContext()
            if !self.checkData(id: game.idGame) {
                taskContext.performAndWait {
                    if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: taskContext) {
                        let favorite = NSManagedObject(entity: entity, insertInto: taskContext)

                        favorite.setValue(game.idGame, forKey: "id")
                        favorite.setValue(game.name, forKey: "name")
                        favorite.setValue(game.rating, forKey: "rating")
                        favorite.setValue(game.released, forKey: "released")
                        favorite.setValue(game.backgroundImagePath, forKey: "backgroundImage")
                        favorite.setValue(game.genres, forKey: "genres")
                        favorite.setValue(isFavorite, forKey: "isFavorite")
                        do {
                            try taskContext.save()
                            promise(.success(()))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            } else {
                promise(.failure(NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Data sudah ada pada favorite"]
                )))
            }
        }
    }

    public func deleteAllFavorite() -> Future<Void, Error> {
        return Future { promise in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeCount
                if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                    batchDeleteResult.result != nil {
                    promise(.success(()))
                }
            }
        }
    }

    public func checkData(id: Int) -> Bool {
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        var results: [NSManagedObject] = []

        do {
            results = try taskContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return results.count > 0
    }

    public func deleteFavorite(_ id: Int) -> Future<Void, Error> {
        return Future { promise in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeCount
                if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                    batchDeleteResult.result != nil {
                    promise(.success(()))
                }
            }
        }
    }
}
