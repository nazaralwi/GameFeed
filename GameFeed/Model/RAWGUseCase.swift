//
//  RAWGUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

protocol GameDataSourceProtocol {
    func getGames() -> [GameEntity]
    func getGameDetail() -> GameEntity
}

class GameDataSource: GameDataSourceProtocol {
    func getGames() -> [GameEntity] {
        return []
    }

    func getGameDetail() -> GameEntity {
        return GameEntity(idGame: 0, name: "", released: Date.distantFuture, description: "", rating: 0, backgroundImage: URL(string: "")!, genres: [], platforms: [], publishers: [], metacritic: 0)
    }
}

protocol GameRepositoryProtocol {
    func getGames() -> [GameEntity]
    func getGameDetail() -> GameEntity
}

class GameRepository: GameRepositoryProtocol {
    private let gameDataSource: GameDataSourceProtocol

    init(gameDataSource: GameDataSourceProtocol) {
        self.gameDataSource = gameDataSource
    }

    func getGames() -> [GameEntity] {
        return gameDataSource.getGames()
    }

    func getGameDetail() -> GameEntity {
        return gameDataSource.getGameDetail()
    }
}

protocol RAWGUseCase {
    func getGames() -> [GameEntity]
    func getGameDetail() -> GameEntity
}

class RAWGInteractor: RAWGUseCase {
    private let gameRepository: GameRepositoryProtocol

    init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }

    func getGames() -> [GameEntity] {
        return gameRepository.getGames()
    }

    func getGameDetail() -> GameEntity {
        return gameRepository.getGameDetail()
    }
}
