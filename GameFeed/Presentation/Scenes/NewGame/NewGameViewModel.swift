//
//  NewGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 05/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit

public protocol NewGameViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class NewGameViewModel {
    @Published public var games: [GameUIModel] = []

    private var gameFeedUseCase: GameFeedUseCase

    public weak var delegate: NewGameViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
    }

    public func fetchNewGame(lastMonth: String, now: String) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        Task {
            do {
                let result = try await gameFeedUseCase.getNewGameLastMonths(
                    lastMonth: lastMonth,
                    now: now
                )

                let mappedGames = result.map { GameMapper.mapGameModelToGameUIModel(game: $0) }
                self.games = mappedGames

                await MainActor.run {
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                    self.delegate?.didUpdateGames()
                }
            } catch {
                await MainActor.run {
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
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
