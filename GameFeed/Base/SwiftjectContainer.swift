//
//  SwiftjectContainer.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Swinject
import GameFeedDomain

class SwinjectContainer {
    private static var container: Container = {
        let container = Container { container in
            container.register(Networking.self) { _ in AlamofireNetworking() }
            container.register(GameRemoteDataSource.self) { resolver in
                GameRemoteDataSource(networking: resolver.resolve(Networking.self)!)
            }

            container.register(CoreDataFavoriteDataSource.self) { _ in CoreDataFavoriteDataSource() }

            container.register(UserDefaultProfileDataSource.self) { _ in UserDefaultProfileDataSource() }

            container.register(GameFeedUseCase.self) { resolver in
                GameFeedUseCase(rawgService: resolver.resolve(GameRemoteDataSource.self)!)
            }

            container.register(FavoriteUseCase.self) { resolver in
                FavoriteUseCase(favoriteProvider: resolver.resolve(CoreDataFavoriteDataSource.self)!)
            }

            container.register(ProfileUseCase.self) { resolver in
                ProfileUseCase(profileProvider: resolver.resolve(UserDefaultProfileDataSource.self)!)
            }

            container.register(HomeViewModel.self) { resolver in
                HomeViewModel(gameFeedUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(SearchGameViewModel.self) { resolver in
                SearchGameViewModel(gameFeedUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(NewGameViewModel.self) { resolver in
                NewGameViewModel(gameFeedUseCase: resolver.resolve(GameFeedUseCase.self)!)
            }

            container.register(MyProfileViewModel.self) { resolver in
                MyProfileViewModel(profileUseCase: resolver.resolve(ProfileUseCase.self)!)
            }

            container.register(DetailViewModel.self) { resolver in
                DetailViewModel(
                    gameFeedUseCase: resolver.resolve(GameFeedUseCase.self)!,
                    favoriteUseCase: resolver.resolve(FavoriteUseCase.self)!
                )
            }

            container.register(FavoritesViewModel.self) { resolver in
                FavoritesViewModel(
                    gameFeedUseCase: resolver.resolve(GameFeedUseCase.self)!,
                    favoriteUseCase: resolver.resolve(FavoriteUseCase.self)!
                )
            }
        }

        return container
    }()

    private init() { }

    public static func getContainer() -> Container {
        return container
    }
}
