//
//  SearchGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 05/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

protocol SearchGameViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

class SearchGameViewModel {
    @Published var games: [GameUIModel] = []
    @Published var loadingIndicator: Bool = false
    @Published var gameBackground: UIImage?
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private var currentSearchTask: AnyCancellable?

    private var rawgUseCase: RAWGUseCase

    weak var delegate: SearchGameViewModelDelegate?

    init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    func searchGames(query: String) {
        self.loadingIndicator = true
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        currentSearchTask?.cancel()

        currentSearchTask = rawgUseCase.search(query: query)
            .sink(receiveCompletion: { completion in
                self.loadingIndicator = false
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)

                if case .failure(let error) = completion {
                    print("Search failed with error: \(error)")
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }, receiveValue: { games in
                if !games.isEmpty {
                    self.games = games
                    self.delegate?.didUpdateGames()
                }

                self.loadingIndicator = false
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)
            })

        if currentSearchTask != nil {
            currentSearchTask?.store(in: &cancellables)
        }
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
