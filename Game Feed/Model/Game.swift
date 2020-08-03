//
//  Game.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 03/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

class Game {
    let title: String
    let rate: String
    let description: String
    
    init(title: String, rate: String, description: String) {
        self.title = title
        self.rate = rate
        self.description = description
    }
}
