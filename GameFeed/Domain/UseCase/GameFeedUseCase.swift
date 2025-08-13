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

    private let rawgService: GameRemoteDataSourceProtocol

    public init(rawgService: GameRemoteDataSourceProtocol) {
        self.rawgService = rawgService
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
}
