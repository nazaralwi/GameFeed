//
//  RAWGUseCaseTests.swift
//  GameFeedTests
//
//  Created by Macintosh on 28/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import XCTest
import Combine
@testable import GameFeed
@testable import GameFeedDomain

class MockGameRemoteDateSource: GameRemoteDataSourceProtocol {
    var getGameListCalled = false
    var searchCalled = false
    var getGameDetailCalled = false
    var getNewGameLastMonthsCalled = false
    var downloadBackgroundCalled = false

    func getGameList() -> AnyPublisher<[GameModel], Error> {
        getGameListCalled = true
        return Just([GameModel]())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func search(query: String) -> AnyPublisher<[GameModel], Error> {
        searchCalled = true
        return Just([GameModel]())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getGameDetail(idGame: Int) -> AnyPublisher<GameModel, Error> {
        getGameDetailCalled = true
        let game = GameModel(
            idGame: 123,
            name: "A game",
            released: "A release date",
            description: "A description",
            rating: "A rating",
            backgroundImagePath: "A background image",
            genres: "Some genres",
            platforms: "Some platforms",
            publishers: "Some publishers",
            metacritic: 0)

        return Just(game)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameModel], Error> {
        getNewGameLastMonthsCalled = true
        return Just([GameModel]())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        downloadBackgroundCalled = true
        return Just(Data())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class GameFeedUseCaseTests: XCTestCase {

    var gameFeedUseCase: GameFeedUseCase!
    var mockGameRemoteDataSource: MockGameRemoteDateSource!
    var mockFavoriteProvider: MockFavoriteProvider!
    var mockProfileProvider: MockProfileProvider!

    override func setUp() {
        super.setUp()
        mockGameRemoteDataSource = MockGameRemoteDateSource()
        gameFeedUseCase = GameFeedUseCase(gameRemoteDataSource: mockGameRemoteDataSource)
    }

    func testGetGameList() {
        _ = gameFeedUseCase.getGameList()
        XCTAssertTrue(mockGameRemoteDataSource.getGameListCalled)
    }

    func testSearch() {
        _ = gameFeedUseCase.search(query: "test")
        XCTAssertTrue(mockGameRemoteDataSource.searchCalled)
    }

    func testGetGameDetail() {
        _ = gameFeedUseCase.getGameDetail(idGame: 1)
        XCTAssertTrue(mockGameRemoteDataSource.getGameDetailCalled)
    }

    func testGetNewGameLastMonths() {
        _ = gameFeedUseCase.getNewGameLastMonths(lastMonth: "2023-01", now: "2023-02")
        XCTAssertTrue(mockGameRemoteDataSource.getNewGameLastMonthsCalled)
    }

    func testDownloadBackground() {
        _ = gameFeedUseCase.downloadBackground(backgroundPath: "path/to/background")
        XCTAssertTrue(mockGameRemoteDataSource.downloadBackgroundCalled)
    }
}
