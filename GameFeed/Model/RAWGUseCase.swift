//
//  RAWGUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine

public final class RAWGUseCase {

    private let rawgService: RAWGService
    private let favoriteProvider: FavoriteProvider

    public init(rawgService: RAWGService, favoriteProvider: FavoriteProvider) {
        self.rawgService = rawgService
        self.favoriteProvider = favoriteProvider
    }

    public func getGameList() -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.getGameList()
    }

    public func search(query: String) -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.search(query: query)
    }

    public func getGameDetail(idGame: Int) -> AnyPublisher<GameUIModel, Error> {
        return rawgService.getGameDetail(idGame: idGame)
    }

    public func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.getNewGameLastMonths(lastMonth: lastMonth, now: now)
    }

    public func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        return rawgService.downloadBackground(backgroundPath: backgroundPath)
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

    public func getProfileModelData() -> DeveloperProfile {
        return DeveloperProfile(name: ProfileModel.name, company: ProfileModel.company, email: ProfileModel.email)
    }

    public func setProfileModellData(name: String, company: String, email: String) {
        ProfileModel.name = name
        ProfileModel.company = company
        ProfileModel.email = email
    }

    public func deleteAllProfileModel() {
        ProfileModel.synchronize()
    }

    public func synchronizeProfileModel() {
        ProfileModel.synchronize()
    }
}
