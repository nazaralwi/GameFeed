//
//  DetailViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 04/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

protocol DetailViewModelDelegate: AnyObject {
    func didLoadDetailGame(game: GameUIModel)
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didFetchFavoriteState(isFavorite: Bool)
    func didUpdateFavoriteState(isFavorite: Bool)
    func didReceivedError(message: String)
}

class DetailViewModel {
    @Published var gameDetail: GameUIModel?
    @Published var isFavorite: Bool?
    @Published var loadingIndicator: Bool?
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private var rawgUseCase: RAWGUseCase

    weak var delegate: DetailViewModelDelegate?

    init(rawgUseCase: RAWGUseCase) {
        self.rawgUseCase = rawgUseCase
    }

    func fetchGameDetail(idGame: Int) {
        self.loadingIndicator = true
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        rawgUseCase.getGameDetail(idGame: idGame)
            .flatMap { [self] gameDetail -> AnyPublisher<(GameUIModel, Data?), Error> in
                let backgroundPublisher: AnyPublisher<Data?, Error>
                if let backgroundPath = gameDetail.backgroundImage {
                    backgroundPublisher = rawgUseCase.downloadBackground(backgroundPath: backgroundPath)
                        .map { Optional($0) }
                        .catch { _ in Just(nil).setFailureType(to: Error.self) }
                        .eraseToAnyPublisher()
                } else {
                    backgroundPublisher = Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return backgroundPublisher.map { (gameDetail, $0) }.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                self.loadingIndicator = false
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)

                if case .failure(let error) = completion {
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }, receiveValue: { gameDetail, imageData in
                self.gameDetail = gameDetail
                if let imageData = imageData {
                    self.gameDetail?.downloadedBackgroundImage = UIImage(data: imageData)
                }
                self.delegate?.didLoadDetailGame(game: self.gameDetail!)

                self.loadingIndicator = false
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)

            })
            .store(in: &cancellables)
    }

    func fetchFavoriteState(for gameId: Int) {
        let isFavorite = rawgUseCase.checkData(id: gameId)
        self.isFavorite = isFavorite
        self.delegate?.didFetchFavoriteState(isFavorite: isFavorite)
    }

    func addGameToFavorite(_ game: GameUIModel) {
        _ = rawgUseCase.addToFavorite(game: game, true)
    }

    func deleteGameFavorite(_ gameId: Int) {
        _ = rawgUseCase.deleteFavorite(gameId)
    }

    func updateFavoriteState(for gameId: Int) {
        if !rawgUseCase.checkData(id: gameId) {
            self.isFavorite = true
            self.delegate?.didUpdateFavoriteState(isFavorite: true)
        } else {
            self.isFavorite = false
            self.delegate?.didUpdateFavoriteState(isFavorite: false)
        }
    }
}
