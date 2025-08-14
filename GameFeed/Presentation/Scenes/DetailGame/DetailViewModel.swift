//
//  DetailViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 04/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit
import Combine

public protocol DetailViewModelDelegate: AnyObject {
    func didLoadDetailGame(game: GameUIModel)
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didFetchFavoriteState(isFavorite: Bool)
    func didUpdateFavoriteState(isFavorite: Bool)
    func didReceivedError(message: String)
}

public final class DetailViewModel {
    @Published public var gameDetail: GameUIModel?

    private var cancellables = Set<AnyCancellable>()
    private var gameFeedUseCase: GameFeedUseCase
    private var favoriteUseCase: FavoriteUseCase

    public weak var delegate: DetailViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase, favoriteUseCase: FavoriteUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
        self.favoriteUseCase = favoriteUseCase
    }

    public func fetchGameDetail(idGame: Int) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        gameFeedUseCase.getGameDetail(idGame: idGame)
            .flatMap { [self] gameDetail -> AnyPublisher<(GameUIModel, Data?), Error> in
                let backgroundPublisher: AnyPublisher<Data?, Error>

                let mappedGameDetail = GameMapper.mapGameModelToGameUIModel(game: gameDetail)

                backgroundPublisher = gameFeedUseCase
                    .downloadBackground(backgroundPath: mappedGameDetail.backgroundImagePath)
                    .map { Optional($0) }
                    .catch { _ in Just(nil).setFailureType(to: Error.self) }
                    .eraseToAnyPublisher()

                return backgroundPublisher.map { (mappedGameDetail, $0) }.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
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
                self.delegate?.didUpdateLoadingIndicator(isLoading: false)

            })
            .store(in: &cancellables)

        let isFavorite = favoriteUseCase.checkData(id: idGame)
        self.delegate?.didFetchFavoriteState(isFavorite: isFavorite)
    }

    public func addGameToFavorite(_ game: GameUIModel) {
        _ = favoriteUseCase.addToFavorite(game: GameMapper.mapGameUIModelToGameModel(game: game), true)
    }

    public func deleteGameFavorite(_ gameId: Int) {
        _ = favoriteUseCase.deleteFavorite(gameId)
    }

    public func updateFavoriteState(for gameId: Int) {
        if !favoriteUseCase.checkData(id: gameId) {
            self.delegate?.didUpdateFavoriteState(isFavorite: true)
        } else {
            self.delegate?.didUpdateFavoriteState(isFavorite: false)
        }
    }
}
