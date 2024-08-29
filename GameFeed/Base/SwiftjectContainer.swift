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

            container.register(GameFeedUseCase.self) { resolver in
                GameFeedUseCase(
                    rawgService: resolver.resolve(RAWGService.self)!,
                    favoriteProvider: resolver.resolve(FavoriteProvider.self)!)
            }

            container.register(HomeViewModel.self) { resolver in
                HomeViewModel(rawgUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(DetailViewModel.self) { resolver in
                DetailViewModel(rawgUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(SearchGameViewModel.self) { resolver in
                SearchGameViewModel(rawgUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(NewGameViewModel.self) { resolver in
                NewGameViewModel(rawgUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(FavoritesViewModel.self) { resolver in
                FavoritesViewModel(rawgUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(MyProfileViewModel.self) { resolver in
                MyProfileViewModel(rawgUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }.inObjectScope(.container)

            container.storyboardInitCompleted(ViewController.self) { resolver, viewController in
                viewController.viewModel = resolver.resolve(HomeViewModel.self)
            }

            container.storyboardInitCompleted(DetailGameViewController.self) { resolver, detailViewController in
                detailViewController.viewModel = resolver.resolve(DetailViewModel.self)
            }

            container.storyboardInitCompleted(SearchGameViewController.self) { resolver, searchGameViewController in
                searchGameViewController.viewModel = resolver.resolve(SearchGameViewModel.self)
            }

            container.storyboardInitCompleted(NewGameViewController.self) { resolver, newGameViewController in
                newGameViewController.viewModel = resolver.resolve(NewGameViewModel.self)
            }

            container.storyboardInitCompleted(FavoritesViewController.self) { resolver, favoritesViewController in
                favoritesViewController.viewModel = resolver.resolve(FavoritesViewModel.self)
            }

            container.storyboardInitCompleted(MyProfileViewController.self) { resolver, myProfileViewController in
                myProfileViewController.viewModel = resolver.resolve(MyProfileViewModel.self)
            }

            container.storyboardInitCompleted(UpdateViewController.self) { resolver, updateProfileViewController in
                updateProfileViewController.viewModel = resolver.resolve(MyProfileViewModel.self)
            }
        }

        return container
    }()

    private init() { }

    public static func getContainer() -> Container {
        return container
    }
}
