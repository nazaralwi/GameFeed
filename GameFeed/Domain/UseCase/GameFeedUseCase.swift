//
//  RAWGUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine

public final class GameFeedUseCase {

    private let gameRemoteDataSource: GameRemoteDataSourceProtocol

    public init(rawgService: GameRemoteDataSourceProtocol) {
        self.gameRemoteDataSource = rawgService
    }

    public func getGameList() -> AnyPublisher<[GameModel], Error> {
        return gameRemoteDataSource.getGameList()
    }

    public func search(query: String) -> AnyPublisher<[GameModel], Error> {
        return gameRemoteDataSource.search(query: query)
    }

    public func getGameDetail(idGame: Int) -> AnyPublisher<GameModel, Error> {
        return gameRemoteDataSource.getGameDetail(idGame: idGame)
    }

    public func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameModel], Error> {
        return gameRemoteDataSource.getNewGameLastMonths(lastMonth: lastMonth, now: now)
    }

    public func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        return gameRemoteDataSource.downloadBackground(backgroundPath: backgroundPath)
    }
}
