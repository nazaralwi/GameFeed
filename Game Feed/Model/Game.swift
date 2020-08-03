//
//  Game.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 03/08/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import UIKit

class Game {
    let title: String
    let rate: String
    let description: String
    let photo: UIImage
    
    init(title: String, rate: String, description: String, photo: UIImage) {
        self.title = title
        self.rate = rate
        self.description = description
        self.photo = photo
    }
}
