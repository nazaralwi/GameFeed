import CoreData

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
        let context = persistentContainer.newBackgroundContext()
        context.undoManager = nil

        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    public func getAllFavorites() throws -> [GameModel] {
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")

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

        return favorites.map { GameMapper.mapGameFavoriteModelToGameModel(game: $0) }
    }

    public func getFavorite(_ id: Int) throws -> GameModel {
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")

        guard let result = try taskContext.fetch(fetchRequest).first else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Favorite not found"])
        }

        let favorite =  FavoriteModel(
            id: result.value(forKeyPath: "id") as? Int64,
            name: result.value(forKeyPath: "name") as? String,
            released: result.value(forKeyPath: "released") as? String,
            rating: result.value(forKeyPath: "rating") as? String,
            backgroundImagePath: result.value(forKeyPath: "backgroundImage") as? String,
            genres: result.value(forKeyPath: "genres") as? String)

        return GameMapper.mapGameFavoriteModelToGameModel(game: favorite)
    }

    public func addToFavorite(game: GameModel, _ isFavorite: Bool) throws {
        let taskContext = newTaskContext()
        if checkData(id: game.idGame) {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Favorite not found"])
        }

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
                try? taskContext.save()
            }
        }
    }

    public func deleteAllFavorite() throws {
        let taskContext = self.newTaskContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount
        _ = try taskContext.execute(batchDeleteRequest)
    }

    public func checkData(id: Int) -> Bool {
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)

        do {
            let result = try taskContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Failed to fetch Favorite with id \(id): \(error)")
            return false
        }
    }

    public func deleteFavorite(_ id: Int) throws {
        let taskContext = self.newTaskContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount
        _ = try taskContext.execute(batchDeleteRequest)
    }
}
