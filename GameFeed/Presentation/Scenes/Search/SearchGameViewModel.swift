//
//  SearchGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 05/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit

public protocol SearchGameViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class SearchGameViewModel {
    @Published public var games: [GameUIModel] = []

    private var currentSearchTask: Task<Void, Never>?
    private var gameFeedUseCase: GameFeedUseCase

    public weak var delegate: SearchGameViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
    }

    public func searchGames(query: String) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        currentSearchTask?.cancel()

        currentSearchTask = Task {
            do {
                let result = try await gameFeedUseCase.search(query: query)

                try Task.checkCancellation()

                let mappedGames = result.map { GameMapper.mapGameModelToGameUIModel(game: $0) }

                await MainActor.run {
                    self.games = mappedGames
                    self.delegate?.didUpdateGames()
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                }
            } catch is CancellationError {
                print("Cancelling task")
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
