//
//  Platforms.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 16/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

struct Platforms: Codable {
    let platform: Platform
    let releasedAt: String
    let requirements: Requirement
    
    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}
