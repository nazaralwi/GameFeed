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

class MockRAWGService: RAWGServiceProtocol {
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

class MockFavoriteProvider: FavoriteProviderProtocol {
    var getAllFavoritesCalled = false
    var getFavoriteCalled = false
    var addToFavoriteCalled = false
    var deleteAllFavoriteCalled = false
    var checkDataCalled = false
    var deleteFavoriteCalled = false

    func getAllFavorites() -> Future<[FavoriteModel], Error> {
        getAllFavoritesCalled = true
        return Future { promise in
            promise(.success([FavoriteModel]()))
        }
    }

    func getFavorite(_ id: Int) -> Future<FavoriteModel, Error> {
        getFavoriteCalled = true
        return Future { promise in
            promise(.success(FavoriteModel()))
        }
    }

    func addToFavorite(game: GameUIModel, _ isFavorite: Bool) -> Future<Void, Error> {
        addToFavoriteCalled = true
        return Future { promise in
            promise(.success(()))
        }
    }

    func deleteAllFavorite() -> Future<Void, Error> {
        deleteAllFavoriteCalled = true
        return Future { promise in
            promise(.success(()))
        }
    }

    func checkData(id: Int) -> Bool {
        checkDataCalled = true
        return true
    }

    func deleteFavorite(_ id: Int) -> Future<Void, Error> {
        deleteFavoriteCalled = true
        return Future { promise in
            promise(.success(()))
        }
    }
}

final class GameFeedUseCaseTests: XCTestCase {

    var rawgUseCase: GameFeedUseCase!
    var mockRAWGService: MockRAWGService!
    var mockFavoriteProvider: MockFavoriteProvider!

    override func setUp() {
        super.setUp()
        mockRAWGService = MockRAWGService()
        mockFavoriteProvider = MockFavoriteProvider()
        rawgUseCase = GameFeedUseCase(rawgService: mockRAWGService, favoriteProvider: mockFavoriteProvider)
    }

    func testGetGameList() {
        _ = rawgUseCase.getGameList()
        XCTAssertTrue(mockRAWGService.getGameListCalled)
    }

    func testSearch() {
        _ = rawgUseCase.search(query: "test")
        XCTAssertTrue(mockRAWGService.searchCalled)
    }

    func testGetGameDetail() {
        _ = rawgUseCase.getGameDetail(idGame: 1)
        XCTAssertTrue(mockRAWGService.getGameDetailCalled)
    }

    func testGetNewGameLastMonths() {
        _ = rawgUseCase.getNewGameLastMonths(lastMonth: "2023-01", now: "2023-02")
        XCTAssertTrue(mockRAWGService.getNewGameLastMonthsCalled)
    }

    func testDownloadBackground() {
        _ = rawgUseCase.downloadBackground(backgroundPath: "path/to/background")
        XCTAssertTrue(mockRAWGService.downloadBackgroundCalled)
    }

    func testGetAllFavorites() {
        _ = rawgUseCase.getAllFavorites()
        XCTAssertTrue(mockFavoriteProvider.getAllFavoritesCalled)
    }

    func testGetFavorite() {
        _ = rawgUseCase.getFavorite(1)
        XCTAssertTrue(mockFavoriteProvider.getFavoriteCalled)
    }

    func testAddToFavorite() {
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
        _ = rawgUseCase.addToFavorite(game: game, true)
        XCTAssertTrue(mockFavoriteProvider.addToFavoriteCalled)
    }

    func testDeleteAllFavorite() {
        _ = rawgUseCase.deleteAllFavorite()
        XCTAssertTrue(mockFavoriteProvider.deleteAllFavoriteCalled)
    }

    func testCheckData() {
        _ = rawgUseCase.checkData(id: 1)
        XCTAssertTrue(mockFavoriteProvider.checkDataCalled)
    }

    func testDeleteFavorite() {
        _ = rawgUseCase.deleteFavorite(1)
        XCTAssertTrue(mockFavoriteProvider.deleteFavoriteCalled)
    }
}
