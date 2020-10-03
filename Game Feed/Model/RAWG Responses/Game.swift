//
//  Game.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 03/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct Game: Codable {
    let id: Int
    let slug: String
    let name: String
    let released: String
    let tba: Bool
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int
    let ratings: Rating
    let ratingsCount: Int
    let reviewsTextCount: String
    let added: String
    let addedByStatus: Bool
    let metacritic: Int
    let playtime: Int
    let suggestionsCount: Int
    let userGame: Int
    let reviewsCount: Int
    let saturatedColor: String
    let dominantColor: String
    let platforms: Platforms
    let parentPlatforms: [Platform]
    let genres: [Genre]
    let stores: Int
    let clip: Int
    let tags: Int
    let shortScreenshots: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case released
        case tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "review_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic
        case playtime
        case suggestionsCount = "suggestions_count"
        case userGame = "user_game"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case platforms
        case parentPlatforms = "parent_platforms"
        case genres
        case stores
        case clip
        case tags
        case shortScreenshots = "short_screenshots"
    }
}
