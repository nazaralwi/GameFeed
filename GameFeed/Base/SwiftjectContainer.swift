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

            container.register(FavoriteProvider.self) { _ in FavoriteProvider() }

            container.register(RAWGUseCase.self) { resolver in
                RAWGUseCase(
                    rawgService: resolver.resolve(RAWGService.self)!,
                    favoriteProvider: resolver.resolve(FavoriteProvider.self)!)
            }

            container.register(HomeViewModel.self) { resolver in
                HomeViewModel(rawgUseCase: resolver.resolve(RAWGUseCase.self)!)
            }

            container.storyboardInitCompleted(ViewController.self) { resolver, viewController in
                viewController.gameViewModel = resolver.resolve(HomeViewModel.self)
            }

            container.storyboardInitCompleted(DetailGameViewController.self) { resolver, detailViewController in
                detailViewController.rawgUseCase = resolver.resolve(RAWGUseCase.self)
            }

            container.storyboardInitCompleted(SearchGameViewController.self) { resolver, searchGameViewController in
                searchGameViewController.rawgUseCase = resolver.resolve(RAWGUseCase.self)
            }

            container.storyboardInitCompleted(NewGameViewController.self) { resolver, newGameViewController in
                newGameViewController.rawgUseCase = resolver.resolve(RAWGUseCase.self)
            }

            container.storyboardInitCompleted(FavoritesViewController.self) { resolver, favoritesViewController in
                favoritesViewController.rawgUseCase = resolver.resolve(RAWGUseCase.self)
            }
        }

        return container
    }()

    private init() { }

    public static func getContainer() -> Container {
        return container
    }
}
