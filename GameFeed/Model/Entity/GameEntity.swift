//
//  GameEntity.swift
//  GameFeed
//
//  Created by Macintosh on 18/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct GameEntity {
    let idGame: Int
    let name: String
    let released: Date?
    let description: String?
    let rating: Double
    let backgroundImage: URL?
    let genres: [GenreResponse]?
    let platforms: [PlatformsResponse]
    let publishers: [PublisherResponse]
    let metacritic: Int?
}
