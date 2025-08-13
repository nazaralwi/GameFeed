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

class MockRAWGService: GameRemoteDataSourceProtocol {
    var getGameListCalled = false
    var searchCalled = false
    var getGameDetailCalled = false
    var getNewGameLastMonthsCalled = false
    var downloadBackgroundCalled = false

    func getGameList() -> AnyPublisher<[GameUIModel], Error> {
        getGameListCalled = true
        return Just([GameUIModel]())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func search(query: String) -> AnyPublisher<[GameUIModel], Error> {
        searchCalled = true
        return Just([GameUIModel]())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getGameDetail(idGame: Int) -> AnyPublisher<GameUIModel, Error> {
        getGameDetailCalled = true
        let game = GameUIModel(
            idGame: 123,
            name: "A game",
            released: "A release date",
            description: "A description",
            rating: "A rating",
            backgroundImage: "A background image",
            genres: "Some genres",
            platforms: "Some platforms",
            publishers: "Some publishers",
            metacritic: 0)

        return Just(game)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameUIModel], Error> {
        getNewGameLastMonthsCalled = true
        return Just([GameUIModel]())
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
    var mockRAWGService: MockRAWGService!
    var mockFavoriteProvider: MockFavoriteProvider!
    var mockProfileProvider: MockProfileProvider!

    override func setUp() {
        super.setUp()
        mockRAWGService = MockRAWGService()
        gameFeedUseCase = GameFeedUseCase(rawgService: mockRAWGService)
    }

    func testGetGameList() {
        _ = gameFeedUseCase.getGameList()
        XCTAssertTrue(mockRAWGService.getGameListCalled)
    }

    func testSearch() {
        _ = gameFeedUseCase.search(query: "test")
        XCTAssertTrue(mockRAWGService.searchCalled)
    }

    func testGetGameDetail() {
        _ = gameFeedUseCase.getGameDetail(idGame: 1)
        XCTAssertTrue(mockRAWGService.getGameDetailCalled)
    }

    func testGetNewGameLastMonths() {
        _ = gameFeedUseCase.getNewGameLastMonths(lastMonth: "2023-01", now: "2023-02")
        XCTAssertTrue(mockRAWGService.getNewGameLastMonthsCalled)
    }

    func testDownloadBackground() {
        _ = gameFeedUseCase.downloadBackground(backgroundPath: "path/to/background")
        XCTAssertTrue(mockRAWGService.downloadBackgroundCalled)
    }
}
