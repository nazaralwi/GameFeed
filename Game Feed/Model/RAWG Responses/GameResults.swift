//
//  GameResults.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 16/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct GameResult: Codable {
    let count: Int
    let next: String
    let results: [Game]
}
