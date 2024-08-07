//
//  FavoriteGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 07/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

protocol FavoritesViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

class FavoritesViewModel {
    @Published var games: [GameUIModel] = []
    @Published var loadingIndicator: Bool = false
    @Published var gameBackground: UIImage?
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private var rawgUseCase: RAWGUseCase

    weak var delegate: FavoritesViewModelDelegate?

    init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    func fetchUsers() {
        self.loadingIndicator = true
        self.rawgUseCase.getAllFavorites()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.loadingIndicator = false
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.loadingIndicator = false
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }, receiveValue: { favorites in
                let mappedFavorites = favorites.map {  GameMapper.mapGameFavoriteModelToGameUIModel(game: $0)
                }
                self.games = mappedFavorites
                self.loadingIndicator = false
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                self.delegate?.didUpdateGames()
            })
            .store(in: &cancellables)

    }

    func fetchBackground(for game: GameUIModel) {
        guard let backgroundPath = game.backgroundImage else { return }

        rawgUseCase.downloadBackground(backgroundPath: backgroundPath)
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
