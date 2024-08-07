//
//  GameMapper.swift
//  GameFeed
//
//  Created by Macintosh on 21/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

class GameMapper {
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

    static func mapGameFavoriteModelToGameUIModel(game: FavoriteModel) -> GameUIModel {
        return GameUIModel(idGame: Int(game.id ?? 0),
                           name: game.name ?? "",
                           released: game.released ?? "-",
                           description: nil,
                           rating: game.rating ?? "0.0",
                           backgroundImage: game.backgroundImage,
                           genres: game.genres ?? "-",
                           platforms: nil,
                           publishers: nil,
                           metacritic: nil)
    }
}
