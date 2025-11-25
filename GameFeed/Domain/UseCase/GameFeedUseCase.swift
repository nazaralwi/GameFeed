//
//  GameFeedUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

public protocol GameRemoteDataSourceProtocol {
    func getGameList() async throws -> [GameModel]
    func search(query: String) async throws -> [GameModel]
    func getGameDetail(idGame: Int) async throws -> GameModel
    func getNewGameLastMonths(lastMonth: String, now: String) async throws -> [GameModel]
    func downloadBackground(backgroundPath: String) async throws -> Data
}

public final class GameFeedUseCase {

    private let gameRemoteDataSource: GameRemoteDataSourceProtocol

    public init(gameRemoteDataSource: GameRemoteDataSourceProtocol) {
        self.gameRemoteDataSource = gameRemoteDataSource
    }

    public func getGameList() async throws -> [GameModel] {
        return try await gameRemoteDataSource.getGameList()
    }

    public func search(query: String) async throws -> [GameModel] {
        return try await gameRemoteDataSource.search(query: query)
    }

    public func getGameDetail(idGame: Int) async throws -> GameModel {
        return try await gameRemoteDataSource.getGameDetail(idGame: idGame)
    }

    public func getNewGameLastMonths(lastMonth: String, now: String) async throws -> [GameModel] {
        return try await gameRemoteDataSource.getNewGameLastMonths(lastMonth: lastMonth, now: now)
    }

    public func downloadBackground(backgroundPath: String) async throws -> Data {
        return try await gameRemoteDataSource.downloadBackground(backgroundPath: backgroundPath)
    }
}
