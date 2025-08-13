//
//  FavoriteUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 13/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine

public final class FavoriteUseCase {

    private let favoriteProvider: CoreDataFavoriteDataSourceProtocol

    public init(favoriteProvider: CoreDataFavoriteDataSourceProtocol) {
        self.favoriteProvider = favoriteProvider
    }

    public func getAllFavorites() -> Future<[FavoriteModel], Error> {
        return favoriteProvider.getAllFavorites()
    }

    public func getFavorite(_ id: Int) -> Future<FavoriteModel, Error> {
        return favoriteProvider.getFavorite(id)
    }

    public func addToFavorite(game: GameUIModel, _ isFavorite: Bool) -> Future<Void, Error> {
        return favoriteProvider.addToFavorite(game: game, isFavorite)
    }

    public func deleteAllFavorite() -> Future<Void, Error> {
        return favoriteProvider.deleteAllFavorite()
    }

    public func checkData(id: Int) -> Bool {
        return favoriteProvider.checkData(id: id)
    }

    public func deleteFavorite(_ id: Int) -> Future<Void, Error> {
        return favoriteProvider.deleteFavorite(id)
    }
}
