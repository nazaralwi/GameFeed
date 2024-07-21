//
//  ViewControllerUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 20/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine

class ViewControllerUseCase {
    func getGames() -> AnyPublisher<[GameUIModel], Error> {
        return Future<[GameUIModel], Error> { _ in

        }.eraseToAnyPublisher()
    }
}
