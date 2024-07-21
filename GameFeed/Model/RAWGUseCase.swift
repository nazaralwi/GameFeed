//
//  RAWGUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

class GameMediator {

    private let rawgService: RAWGService

    init(rawgService: RAWGService) {
        self.rawgService = rawgService
    }

    func getGameList() -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.getGameList()
    }

    func search(query: String) -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.search(query: query)
    }

    func getGameDetail(idGame: Int) -> AnyPublisher<GameUIModel, Error> {
        return rawgService.getGameDetail(idGame: idGame)
    }

    func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameUIModel], Error> {
        return rawgService.getNewGameLastMonths(lastMonth: lastMonth, now: now)
    }

    func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        return rawgService.downloadBackground(backgroundPath: backgroundPath)
    }
}

class GameMapper {
    static func mapGameResponseToGameEntity(game: GameResponse) -> GameEntity {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return GameEntity(idGame: game.idGame,
                   name: game.name,
                   released: dateFormatter.date(from: game.released!),
                   description: "",
                   rating: game.rating,
                   backgroundImage: URL(string: game.backgroundImage ?? "")!,
                   genres: game.genres,
                   platforms: [],
                   publishers: [],
                   metacritic: 0)
    }

    static func mapGameEntityToGameUIModel(game: GameEntity) -> GameUIModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: game.released.map { dateFormatter.string(from: $0) } ?? "",
                           description: game.description,
                           rating: String(game.rating),
                           backgroundImage: game.backgroundImage!.absoluteString,
                           genres: Formatter.formatGenre(from: game.genres!),
                           platforms: nil,
                           publishers: nil,
                           metacritic: nil)
    }

    static func mapGameResponseToGameUIModel(game: GameResponse) -> GameUIModel {
        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: Formatter.formatDate(from: game.released),
                           description: nil,
                           rating: String(game.rating),
                           backgroundImage: game.backgroundImage,
                           genres: Formatter.formatGenre(from: game.genres),
                           platforms: nil,
                           publishers: nil,
                           metacritic: nil)
    }

    static func mapGameDetailResponseToGameUIModel(game: GameDetailResponse) -> GameUIModel {
        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: Formatter.formatDate(from: game.released),
                           description: game.description,
                           rating: String(game.rating ?? 0.0),
                           backgroundImage: game.backgroundImage,
                           genres: Formatter.formatGenre(from: game.genres),
                           platforms: Formatter.formatPlatform(from: game.platforms),
                           publishers: Formatter.formatPublisher(from: game.publishers),
                           metacritic: game.metacritic)
    }
}
