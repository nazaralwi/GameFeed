//
//  HomeViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 04/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

public protocol HomeViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class HomeViewModel {
    @Published public var games: [GameUIModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var rawgUseCase: GameFeedUseCase

    public weak var delegate: HomeViewModelDelegate?

    public init(rawgUseCase: GameFeedUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    public func fetchGames() {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)
        rawgUseCase.getGameList().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            case .failure(let error):
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                self.delegate?.didReceivedError(message: error.localizedDescription)
            }
        }, receiveValue: { games in
            self.games = games
            self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            self.delegate?.didUpdateGames()
        })
        .store(in: &cancellables)
    }

    public func fetchBackground(for game: GameUIModel) {
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
