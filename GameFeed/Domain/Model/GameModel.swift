//
//  GameModel.swift
//  GameFeed
//
//  Created by Macintosh on 14/08/25.
//  Copyright © 2025 Dicoding Indonesia. All rights reserved.
//

public struct GameModel {
    public let idGame: Int
    public let name: String
    public let released: String
    public let description: String
    public let rating: String
    public let backgroundImagePath: String
    public let genres: String
    public let platforms: String
    public let publishers: String
    public let metacritic: Int

    public init(idGame: Int, name: String, released: String, description: String, rating: String, backgroundImagePath: String, genres: String, platforms: String, publishers: String, metacritic: Int) {
        self.idGame = idGame
        self.name = name
        self.released = released
        self.description = description
        self.rating = rating
        self.backgroundImagePath = backgroundImagePath
        self.genres = genres
        self.platforms = platforms
        self.publishers = publishers
        self.metacritic = metacritic
    }
}
