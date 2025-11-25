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

class MockGameRemoteDateSource: GameRemoteDataSourceProtocol {
    var getGameListCalled = false
    var searchCalled = false
    var getGameDetailCalled = false
    var getNewGameLastMonthsCalled = false
    var downloadBackgroundCalled = false

    func getGameList() async throws -> [GameModel] {
        getGameListCalled = true
        return []
    }

    func search(query: String) async throws -> [GameModel] {
        searchCalled = true
        return []
    }

    func getGameDetail(idGame: Int) async throws -> GameModel {
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

        return game
    }

    func getNewGameLastMonths(lastMonth: String, now: String) async throws -> [GameModel] {
        getNewGameLastMonthsCalled = true
        return []
    }

    func downloadBackground(backgroundPath: String) async throws -> Data {
        downloadBackgroundCalled = true
        return Data()
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

    func testGetGameList() async {
        do {
            _ = try await gameFeedUseCase.getGameList()
            XCTAssertTrue(mockGameRemoteDataSource.getGameListCalled)
        } catch {
            print(error)
        }
    }

    func testSearch() async {
        do {
            _ = try await gameFeedUseCase.search(query: "test")
            XCTAssertTrue(mockGameRemoteDataSource.searchCalled)
        } catch {
            print(error)
        }
    }

    func testGetGameDetail() async {
        do {
            _ = try await gameFeedUseCase.getGameDetail(idGame: 1)
            XCTAssertTrue(mockGameRemoteDataSource.getGameDetailCalled)
        } catch {
            print(error)
        }
    }

    func testGetNewGameLastMonths() async {
        do {
            _ = try await gameFeedUseCase.getNewGameLastMonths(lastMonth: "2023-01", now: "2023-02")
            XCTAssertTrue(mockGameRemoteDataSource.getNewGameLastMonthsCalled)
        } catch {
            print(error)
        }
    }

    func testDownloadBackground() async {
        do {
            _ = try await gameFeedUseCase.downloadBackground(backgroundPath: "path/to/background")
            XCTAssertTrue(mockGameRemoteDataSource.downloadBackgroundCalled)
        } catch {
            print(error)
        }
    }
}
