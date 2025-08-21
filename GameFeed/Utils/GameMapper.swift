//
//  GameMapper.swift
//  GameFeed
//
//  Created by Macintosh on 21/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import GameFeedDomain

class GameMapper {
    static func mapGameResponseToGameModel(game: GameResponse) -> GameModel {
        return GameModel(idGame: game.idGame,
                         name: game.name,
                         released: Formatter.formatDate(from: game.released),
                         description: "",
                         rating: String(game.rating),
                         backgroundImagePath: Formatter.formatImagePath(from: game.backgroundImagePath),
                         genres: Formatter.formatGenre(from: game.genres),
                         platforms: "",
                         publishers: "",
                         metacritic: 0)
    }

    static func mapGameDetailResponseToGameModel(game: GameDetailResponse) -> GameModel {
        return GameModel(idGame: game.idGame,
                         name: game.name,
                         released: Formatter.formatDate(from: game.released),
                         description: game.description ?? "",
                         rating: String(game.rating ?? 0.0),
                         backgroundImagePath: Formatter.formatImagePath(from: game.backgroundImagePath),
                         genres: Formatter.formatGenre(from: game.genres),
                         platforms: Formatter.formatPlatform(from: game.platforms),
                         publishers: Formatter.formatPublisher(from: game.publishers),
                         metacritic: game.metacritic ?? 0)
    }

    static func mapGameModelToGameUIModel(game: GameModel) -> GameUIModel {
        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: game.released,
                           description: game.description,
                           rating: game.rating,
                           backgroundImagePath: game.backgroundImagePath,
                           genres: game.genres,
                           platforms: game.platforms,
                           publishers: game.publishers,
                           metacritic: game.metacritic)
    }

    static func mapGameUIModelToGameModel(game: GameUIModel) -> GameModel {
        return GameModel(idGame: game.idGame,
                         name: game.name,
                         released: game.released,
                         description: game.description,
                         rating: game.rating,
                         backgroundImagePath: game.backgroundImagePath,
                         genres: game.genres,
                         platforms: game.platforms,
                         publishers: game.publishers,
                         metacritic: game.metacritic)
    }

    static func mapGameFavoriteModelToGameModel(game: FavoriteModel) -> GameModel {
        return GameModel(idGame: Int(game.id ?? 0),
                         name: game.name ?? "-",
                         released: game.released ?? "-",
                         description: "-",
                         rating: game.rating ?? "0.0",
                         backgroundImagePath: Formatter.formatImagePath(from: game.backgroundImagePath),
                         genres: game.genres ?? "-",
                         platforms: "",
                         publishers: "",
                         metacritic: 0)
    }
}
