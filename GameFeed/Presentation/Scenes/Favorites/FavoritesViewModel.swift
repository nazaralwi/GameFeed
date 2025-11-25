//
//  FavoriteGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit

public protocol FavoritesViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class FavoritesViewModel {
    @Published public var games: [GameUIModel] = []

    private var gameFeedUseCase: GameFeedUseCase
    private var favoriteUseCase: FavoriteUseCase

    public weak var delegate: FavoritesViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase, favoriteUseCase: FavoriteUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
        self.favoriteUseCase = favoriteUseCase
    }

    public func fetchUsers() {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        Task {
            do {
                let favorites = try self.favoriteUseCase.getAllFavorites()

                let mappedFavorites = favorites.map { GameMapper.mapGameModelToGameUIModel(game: $0) }

                await MainActor.run {
                    self.games = mappedFavorites
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                    self.delegate?.didUpdateGames()
                }
            } catch {
                await MainActor.run {
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }
        }
    }

    public func fetchBackground(for game: GameUIModel) {
        Task {
            do {
                let data = try await gameFeedUseCase.downloadBackground(backgroundPath: game.backgroundImagePath)

                guard let image = UIImage(data: data) else {
                    return
                }

                if let index = self.games.firstIndex(where: { $0.idGame == game.idGame }) {
                    self.games[index].downloadedBackgroundImage = image
                }

                await MainActor.run {
                    self.delegate?.didUpdateGames()
                }
            } catch {
                print("Image download failed with error: \(error)")
            }
        }
    }
}
