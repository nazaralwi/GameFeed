//
//  GameUIModel.swift
//  GameFeed
//
//  Created by Macintosh on 18/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit

public struct GameUIModel {
    public let idGame: Int
    public let name: String
    public let released: String
    public let description: String
    public let rating: String
    public let backgroundImagePath: String
    public let genres: String
    public let platforms: String
    public let publishers: String
    public let metacritic: Int

    public var downloadedBackgroundImage: UIImage?
}

extension GameUIModel {
    func withBackgroundImage(_ image: UIImage) -> GameUIModel {
        var copy = self
        copy.downloadedBackgroundImage = image
        return copy
    }
}
