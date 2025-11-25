//
//  FavoriteUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 13/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import Foundation

public protocol CoreDataFavoriteDataSourceProtocol {
    func getAllFavorites() throws -> [GameModel]
    func getFavorite(_ id: Int) throws -> GameModel
    func addToFavorite(game: GameModel, _ isFavorite: Bool) throws
    func deleteAllFavorite() throws
    func checkData(id: Int) -> Bool
    func deleteFavorite(_ id: Int) throws
}

public final class FavoriteUseCase {

    private let favoriteProvider: CoreDataFavoriteDataSourceProtocol

    public init(favoriteProvider: CoreDataFavoriteDataSourceProtocol) {
        self.favoriteProvider = favoriteProvider
    }

    public func getAllFavorites() throws -> [GameModel] {
        return try favoriteProvider.getAllFavorites()
    }

    public func getFavorite(_ id: Int) throws -> GameModel {
        return try favoriteProvider.getFavorite(id)
    }

    public func addToFavorite(game: GameModel, _ isFavorite: Bool) throws {
        return try favoriteProvider.addToFavorite(game: game, isFavorite)
    }

    public func deleteAllFavorite() throws {
        return try favoriteProvider.deleteAllFavorite()
    }

    public func checkData(id: Int) -> Bool {
        return favoriteProvider.checkData(id: id)
    }

    public func deleteFavorite(_ id: Int) throws {
        return try favoriteProvider.deleteFavorite(id)
    }
}
