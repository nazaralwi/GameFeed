//
//  Rating.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 16/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct Rating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}
