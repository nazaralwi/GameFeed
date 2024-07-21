//
//  RAWGUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine

class RAWGUseCase {

    private let rawgService: RAWGService
    private let favoriteProvider: FavoriteProvider

    init(rawgService: RAWGService, favoriteProvider: FavoriteProvider) {
        self.rawgService = rawgService
        self.favoriteProvider = favoriteProvider
    }

    func getGameList() -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.getGameList()
    }

    func search(query: String) -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.search(query: query)
    }

    func getGameDetail(idGame: Int) -> AnyPublisher<GameUIModel, Error> {
        return rawgService.getGameDetail(idGame: idGame)
    }

    func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.getNewGameLastMonths(lastMonth: lastMonth, now: now)
    }

    func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        return rawgService.downloadBackground(backgroundPath: backgroundPath)
    }

    func getAllFavorites() -> Future<[FavoriteModel], Error> {
        return favoriteProvider.getAllFavorites()
    }

    func getFavorite(_ id: Int) -> Future<FavoriteModel, Error> {
        return favoriteProvider.getFavorite(id)
    }

    func addToFavorite(game: GameUIModel, _ isFavorite: Bool) -> Future<Void, Error> {
        return favoriteProvider.addToFavorite(game: game, isFavorite)
    }

    func deleteAllFavorite() -> Future<Void, Error> {
        return favoriteProvider.deleteAllFavorite()
    }

    func checkData(id: Int) -> Bool {
        return favoriteProvider.checkData(id: id)
    }

    func deleteFavorite(_ id: Int) -> Future<Void, Error> {
        return favoriteProvider.deleteFavorite(id)
    }
}
