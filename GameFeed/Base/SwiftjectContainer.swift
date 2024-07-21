//
//  SwiftjectContainer.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class SwinjectContainer {
    private static var container: Container = {
        let container = Container { container in
            container.register(Networking.self) { _ in AlamofireNetworking() }
            container.register(RAWGService.self) { resolver in
                RAWGService(networking: resolver.resolve(Networking.self)!)
            }

            container.register(RAWGService.self) { resolver in
                RAWGService(networking: resolver.resolve(Networking.self)!)
            }

            container.storyboardInitCompleted(ViewController.self) { resolver, viewController in
                viewController.rawgService = resolver.resolve(RAWGService.self)
//                viewController.gamePresenter = resolver.resolve()
            }

            container.storyboardInitCompleted(DetailGameViewController.self) { resolver, detailViewController in
                detailViewController.rawgService = resolver.resolve(RAWGService.self)
            }

            container.storyboardInitCompleted(SearchGameViewController.self) { resolver, searchGameViewController in
                searchGameViewController.rawgService = resolver.resolve(RAWGService.self)
            }

            container.storyboardInitCompleted(NewGameViewController.self) { resolver, newGameViewController in
                newGameViewController.rawgService = resolver.resolve(RAWGService.self)
            }

            container.storyboardInitCompleted(FavoritesViewController.self) { resolver, favoritesViewController in
                favoritesViewController.rawgService = resolver.resolve(RAWGService.self)
            }
        }

        return container
    }()

    private init() { }

    public static func getContainer() -> Container {
        return container
    }
}
