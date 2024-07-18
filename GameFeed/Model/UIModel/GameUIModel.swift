//
//  GameUIModel.swift
//  GameFeed
//
//  Created by Macintosh on 18/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct GameFavoriteViewModel {
    let idGame: Int
    let name: String
    let released: String
    let rating: String
    let backgroundImage: String
    let genres: String
}

struct GameFavoriteUIModel {
    let idGame: Int
    let name: String
    let released: String
    let description: String?
    let rating: String
    let backgroundImage: String
    let genres: String
    let platforms: [PlatformsResponse]
    let publishers: [PublisherResponse]
    let metacritic: Int?
}
