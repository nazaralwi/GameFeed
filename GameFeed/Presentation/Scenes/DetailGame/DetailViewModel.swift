//
//  DetailViewModel.swift
//  GameFeed
//
//  Created by Macintosh on 04/08/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import UIKit

public protocol DetailViewModelDelegate: AnyObject {
    func didLoadDetailGame(game: GameUIModel)
    func didUpdateLoadingIndicator(isLoading: Bool)
    func didFetchFavoriteState(isFavorite: Bool)
    func didUpdateFavoriteState(isFavorite: Bool)
    func didReceivedError(message: String)
}

public final class DetailViewModel {
    @Published public var gameDetail: GameUIModel?

    private var gameFeedUseCase: GameFeedUseCase
    private var favoriteUseCase: FavoriteUseCase

    public weak var delegate: DetailViewModelDelegate?

    public init(gameFeedUseCase: GameFeedUseCase, favoriteUseCase: FavoriteUseCase) {
        self.gameFeedUseCase = gameFeedUseCase
        self.favoriteUseCase = favoriteUseCase
    }

    public func fetchGameDetail(idGame: Int) {
        self.delegate?.didUpdateLoadingIndicator(isLoading: true)

        Task {
            do {
                let game = try await gameFeedUseCase.getGameDetail(idGame: idGame)
                var uiModel = GameMapper.mapGameModelToGameUIModel(game: game)

                if let data = try? await gameFeedUseCase.downloadBackground(
                    backgroundPath: uiModel.backgroundImagePath),
                    let image = UIImage(data: data) {
                    uiModel.downloadedBackgroundImage = image
                }

                let isFavorite = favoriteUseCase.checkData(id: idGame)

                await MainActor.run {
                    self.gameDetail = uiModel

                    self.delegate?.didLoadDetailGame(game: uiModel)
                    self.delegate?.didFetchFavoriteState(isFavorite: isFavorite)
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                }
            } catch {
                await MainActor.run {
                    self.delegate?.didUpdateLoadingIndicator(isLoading: false)
                    self.delegate?.didReceivedError(message: error.localizedDescription)
                }
            }
        }
    }

    public func addGameToFavorite(_ game: GameUIModel) {
        Task {
            do {
                try self.favoriteUseCase.addToFavorite(game: GameMapper.mapGameUIModelToGameModel(game: game), true)
            } catch {
                print(error)
            }
        }
    }

    public func deleteGameFavorite(_ gameId: Int) {
        Task {
            do {
                try self.favoriteUseCase.deleteFavorite(gameId)
            } catch {
                print(error)
            }
        }
    }

    public func updateFavoriteState(for gameId: Int) {
        if !favoriteUseCase.checkData(id: gameId) {
            self.delegate?.didUpdateFavoriteState(isFavorite: true)
        } else {
            self.delegate?.didUpdateFavoriteState(isFavorite: false)
        }
    }
}
