//
//  FavoriteUseCaseTest.swift
//  GameFeed
//
//  Created by Macintosh on 13/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

import XCTest
@testable import GameFeed

class MockFavoriteProvider: CoreDataFavoriteDataSourceProtocol {
    var getAllFavoritesCalled = false
    var getFavoriteCalled = false
    var addToFavoriteCalled = false
    var deleteAllFavoriteCalled = false
    var checkDataCalled = false
    var deleteFavoriteCalled = false

    func getAllFavorites() throws -> [GameModel] {
        getAllFavoritesCalled = true
        return [GameModel]()
    }

    func getFavorite(_ id: Int) throws -> GameModel {
        getFavoriteCalled = true
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

    func addToFavorite(game: GameModel, _ isFavorite: Bool) throws {
        addToFavoriteCalled = true
    }

    func deleteAllFavorite() throws {
        deleteAllFavoriteCalled = true
    }

    func checkData(id: Int) -> Bool {
        checkDataCalled = true
        return true
    }

    func deleteFavorite(_ id: Int) throws {
        deleteFavoriteCalled = true
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
        do {
            let result = try favoriteUseCase.getAllFavorites()
            XCTAssertTrue(mockFavoriteProvider.getAllFavoritesCalled)
            XCTAssertEqual(result.count, 0)
        } catch {
            XCTFail("getAllFavorites threw an error: \(error)")
        }
    }

    func testGetFavorite() {
        do {
            _ = try favoriteUseCase.getFavorite(1)
            XCTAssertTrue(mockFavoriteProvider.getFavoriteCalled)
        } catch {
            XCTFail("getFavorite threw an error: \(error)")
        }
    }

    func testAddToFavorite() {
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

        do {
            try favoriteUseCase.addToFavorite(game: game, true)
            XCTAssertTrue(mockFavoriteProvider.addToFavoriteCalled)
        } catch {
            XCTFail("addToFavorite threw an error: \(error)")
        }
    }

    func testDeleteAllFavorite() {
        do {
            _ = try favoriteUseCase.deleteAllFavorite()
            XCTAssertTrue(mockFavoriteProvider.deleteAllFavoriteCalled)
        } catch {
            XCTFail("deleteAllFavorite threw an error: \(error)")
        }
    }

    func testCheckData() {
        _ = favoriteUseCase.checkData(id: 1)
        XCTAssertTrue(mockFavoriteProvider.checkDataCalled)
    }

    func testDeleteFavorite() {
        do {
            _ = try favoriteUseCase.deleteFavorite(1)
            XCTAssertTrue(mockFavoriteProvider.deleteFavoriteCalled)
        } catch {
            XCTFail("deleteFavorite threw an error: \(error)")
        }
    }
}
