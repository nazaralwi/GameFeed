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
    private var rawgUseCase: RAWGUseCase

    public weak var delegate: SearchGameViewModelDelegate?

    public init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    public func searchGames(query: String) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        currentSearchTask?.cancel()

        currentSearchTask = rawgUseCase.search(query: query)
            .sink(receiveCompletion: { completion in
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)

                if case .failure(let error) = completion {
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }, receiveValue: { games in
                if !games.isEmpty {
                    self.games = games
                    self.delegate?.didUpdateGames()
                }

                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            })

        if currentSearchTask != nil {
            currentSearchTask?.store(in: &cancellables)
        }
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
