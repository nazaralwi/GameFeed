//
//  FavoriteGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

public protocol FavoritesViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class FavoritesViewModel {
    @Published public var games: [GameUIModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var gameFeedUseCase: GameFeedUseCase
    private var favoriteUseCase: FavoriteUseCase

    public weak var delegate: FavoritesViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase, favoriteUseCase: FavoriteUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
        self.favoriteUseCase = favoriteUseCase
    }

    public func fetchUsers() {
        self.favoriteUseCase.getAllFavorites()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                case .failure(let error):
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }, receiveValue: { favorites in
                let mappedFavorites = favorites.map {  GameMapper.mapGameFavoriteModelToGameUIModel(game: $0)
                }
                self.games = mappedFavorites
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                self.delegate?.didUpdateGames()
            })
            .store(in: &cancellables)

    }

    public func fetchBackground(for game: GameUIModel) {
        guard let backgroundPath = game.backgroundImage else { return }

        gameFeedUseCase.downloadBackground(backgroundPath: backgroundPath)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Image download finished successfully.")
                case .failure(let error):
                    print("Image download failed with error: \(error)")
                }
            }, receiveValue: { data in
                guard let image = UIImage(data: data) else {
                    return
                }

                if let index = self.games.firstIndex(where: { $0.idGame == game.idGame }) {
                    self.games[index].downloadedBackgroundImage = image
                }
                self.delegate?.didUpdateGames()
            })
            .store(in: &cancellables)
    }
}
