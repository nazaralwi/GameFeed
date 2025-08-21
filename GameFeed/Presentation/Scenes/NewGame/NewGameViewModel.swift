//
//  NewGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 05/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine
import GameFeedDomain

public protocol NewGameViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class NewGameViewModel {
    @Published public var games: [GameUIModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var gameFeedUseCase: GameFeedUseCase

    public weak var delegate: NewGameViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
    }

    public func fetchNewGame(lastMonth: String, now: String) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)
        gameFeedUseCase.getNewGameLastMonths(lastMonth: lastMonth, now: now).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            case .failure(let error):
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                self.delegate?.didReceivedError(message: error.localizedDescription)
            }
        }, receiveValue: { games in
            let mappedGames = games.map { GameMapper.mapGameModelToGameUIModel(game: $0) }
            self.games = mappedGames

            self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            self.delegate?.didUpdateGames()
        })
        .store(in: &cancellables)
    }

    public func fetchBackground(for game: GameUIModel) {
        gameFeedUseCase.downloadBackground(backgroundPath: game.backgroundImagePath)
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
