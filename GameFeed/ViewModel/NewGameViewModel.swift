//
//  NewGameViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 05/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

protocol NewGameViewModelDelegate: AnyObject {
    func didUpdateGames()
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didReceivedError(message: String)
}

class NewGameViewModel {
    @Published var games: [GameUIModel] = []
    @Published var loadingIndicator: Bool = false
    @Published var gameBackground: UIImage?
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private var rawgUseCase: RAWGUseCase

    weak var delegate: NewGameViewModelDelegate?

    init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    func fetchNewGame(lastMonth: String, now: String) {
        self.loadingIndicator = true
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)
        rawgUseCase.getNewGameLastMonths(lastMonth: lastMonth, now: now).sink(receiveCompletion: { completion in
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
        }, receiveValue: { games in
            self.games = games
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
