//
//  Genre.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 18/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
    let gameCount: Int
    let imageBackground: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case gameCount = "games_count"
        case imageBackground = "image_background"
    }
}
