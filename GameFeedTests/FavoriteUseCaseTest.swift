//
//  FavoriteUseCaseTest.swift
//  GameFeed
//
//  Created by Macintosh on 13/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import XCTest
import Combine
@testable import GameFeed

class MockFavoriteProvider: CoreDataFavoriteDataSourceProtocol {
    var getAllFavoritesCalled = false
    var getFavoriteCalled = false
    var addToFavoriteCalled = false
    var deleteAllFavoriteCalled = false
    var checkDataCalled = false
    var deleteFavoriteCalled = false

    func getAllFavorites() -> Future<[GameModel], Error> {
        getAllFavoritesCalled = true
        return Future { promise in
            promise(.success([GameModel]()))
        }
    }

    func getFavorite(_ id: Int) -> Future<GameModel, Error> {
        getFavoriteCalled = true
        let game = GameModel(
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
        return Future { promise in
            promise(.success(game))
        }
    }

    func addToFavorite(game: GameModel, _ isFavorite: Bool) -> Future<Void, Error> {
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

final class FavoriteUseCaseTest: XCTestCase {

    var favoriteUseCase: FavoriteUseCase!
    var mockFavoriteProvider: MockFavoriteProvider!

    override func setUp() {
        super.setUp()
        mockFavoriteProvider = MockFavoriteProvider()
        favoriteUseCase = FavoriteUseCase(favoriteProvider: mockFavoriteProvider)
    }

    func testGetAllFavorites() {
        _ = favoriteUseCase.getAllFavorites()
        XCTAssertTrue(mockFavoriteProvider.getAllFavoritesCalled)
    }

    func testGetFavorite() {
        _ = favoriteUseCase.getFavorite(1)
        XCTAssertTrue(mockFavoriteProvider.getFavoriteCalled)
    }

    func testAddToFavorite() {
        let game = GameModel(
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
        _ = favoriteUseCase.addToFavorite(game: game, true)
        XCTAssertTrue(mockFavoriteProvider.addToFavoriteCalled)
    }

    func testDeleteAllFavorite() {
        _ = favoriteUseCase.deleteAllFavorite()
        XCTAssertTrue(mockFavoriteProvider.deleteAllFavoriteCalled)
    }

    func testCheckData() {
        _ = favoriteUseCase.checkData(id: 1)
        XCTAssertTrue(mockFavoriteProvider.checkDataCalled)
    }

    func testDeleteFavorite() {
        _ = favoriteUseCase.deleteFavorite(1)
        XCTAssertTrue(mockFavoriteProvider.deleteFavoriteCalled)
    }
}
