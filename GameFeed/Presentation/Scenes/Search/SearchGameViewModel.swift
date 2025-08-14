//
//  SearchGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 05/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

public protocol SearchGameViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

public final class SearchGameViewModel {
    @Published public var games: [GameUIModel] = []

    private var cancellables = Set<AnyCancellable>()
    private var currentSearchTask: AnyCancellable?
    private var gameFeedUseCase: GameFeedUseCase

    public weak var delegate: SearchGameViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
    }

    public func searchGames(query: String) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        currentSearchTask?.cancel()

        currentSearchTask = gameFeedUseCase.search(query: query)
            .sink(receiveCompletion: { completion in
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)

                if case .failure(let error) = completion {
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }, receiveValue: { games in
                if !games.isEmpty {
                    let mappedGames = games.map { GameMapper.mapGameModelToGameUIModel(game: $0) }
                    self.games = mappedGames
                    self.delegate?.didUpdateGames()
                }

                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            })

        if currentSearchTask != nil {
            currentSearchTask?.store(in: &cancellables)
        }
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
