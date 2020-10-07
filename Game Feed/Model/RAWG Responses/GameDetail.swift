//
//  GameDetail.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 06/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let released: String
    let description: String
    let rating: Double
    let backgroundImage: String?
    let genres: [Genre]
    let platforms: [Platforms]
    let publishers: [Publisher]
    let metacritic: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case description
        case rating
        case backgroundImage = "background_image"
        case genres
        case platforms
        case publishers
        case metacritic
    }
}
