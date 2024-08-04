//
//  GameUIModel.swift
//  GameFeed
//
//  Created by Macintosh on 18/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit

struct GameUIModel {
    let idGame: Int
    let name: String
    let released: String
    let description: String?
    let rating: String
    let backgroundImage: String?
    let genres: String
    let platforms: String?
    let publishers: String?
    let metacritic: Int?

    var downloadedBackgroundImage: UIImage?
}
