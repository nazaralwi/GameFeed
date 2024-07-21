//
//  RAWGUseCase.swift
//  GameFeed
//
//  Created by Macintosh on 17/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

protocol GameDataSourceProtocol {
    func getGames() -> AnyPublisher<[GameResponse], Error>
    func getGameDetail() -> GameEntity
}

class GameDataSource: GameDataSourceProtocol {
    func getGames() -> AnyPublisher<[GameResponse], Error> {
        return Future<[GameResponse], Error> { completion in
            if let url = Endpoints.getGameList.url {
                AF.request(url)
                    .validate()
                    .responseDecodable(of: GameResultResponse.self) { response in
                        switch response.result {
                        case .success(let gameResult):
                            completion(.success(gameResult.results))
                        case .failure:
                            completion(.failure((URLError.badURL as? Error) ?? NSError(domain: "", code: 0)))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }

    func getGameDetail() -> GameEntity {
        return GameEntity(
            idGame: 0,
            name: "",
            released: Date.distantFuture,
            description: "",
            rating: 0,
            backgroundImage: URL(string: "")!,
            genres: [],
            platforms: [],
            publishers: [],
            metacritic: 0)
    }
}

protocol GameRepositoryProtocol {
    func getGames() -> AnyPublisher<[GameEntity], Error>
    func getGameDetail() -> GameEntity
}

class GameRepository: GameRepositoryProtocol {
    private let gameDataSource: GameDataSourceProtocol

    init(gameDataSource: GameDataSourceProtocol) {
        self.gameDataSource = gameDataSource
    }

    func getGames() -> AnyPublisher<[GameEntity], Error> {
        var cancellables = Set<AnyCancellable>()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format as needed

        return Future<[GameEntity], Error> { completion in
            self.gameDataSource.getGames().sink(receiveCompletion: { receiveCompletion in
                switch receiveCompletion {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { games in
                let mappedGames = games.map {
                    GameMapper.mapGameResponseToGameEntity(game: $0)
                }
                completion(.success(mappedGames))
            })
            .store(in: &cancellables)
        }.eraseToAnyPublisher()
    }

    func getGameDetail() -> GameEntity {
        return gameDataSource.getGameDetail()
    }
}

protocol RAWGUseCase {
    func getGames() -> AnyPublisher<[GameEntity], Error>
    func getGameDetail() -> GameEntity
}

class RAWGInteractor: RAWGUseCase {
    private let gameRepository: GameRepositoryProtocol

    init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }

    func getGames() -> AnyPublisher<[GameEntity], Error> {
        return gameRepository.getGames()
    }

    func getGameDetail() -> GameEntity {
        return gameRepository.getGameDetail()
    }
}

protocol GamePresenterProtocol {
    func getGames() -> AnyPublisher<[GameUIModel], Error>
    func getGameDetail() -> GameUIModel
}

class GamePresenter: GamePresenterProtocol {
    private let gameUseCase: RAWGUseCase

    init(gameUseCase: RAWGUseCase) {
        self.gameUseCase = gameUseCase
    }

    func getGames() -> AnyPublisher<[GameUIModel], Error> {
        var cancellables = Set<AnyCancellable>()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return Future<[GameUIModel], Error> { completion in
            self.gameUseCase.getGames().sink(receiveCompletion: { receivedCompletion in
                switch receivedCompletion {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { games in
                let mappedGames = games.map { game in
                    GameMapper.mapGameEntityToGameUIModel(game: game)
                }
                completion(.success(mappedGames))
            })
            .store(in: &cancellables)
        }.eraseToAnyPublisher()
    }
    
    func getGameDetail() -> GameUIModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let game = gameUseCase.getGameDetail()
        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: game.released.map { dateFormatter.string(from: $0) } ?? "",
                           description: game.description,
                           rating: String(game.rating),
                           backgroundImage: game.backgroundImage!.absoluteString,
                           genres: Formatter.formatGenre(from: game.genres!),
                           platforms: game.platforms,
                           publishers: game.publishers,
                           metacritic: game.metacritic)
    }
}

class GameMapper {
    static func mapGameResponseToGameEntity(game: GameResponse) -> GameEntity {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return GameEntity(idGame: game.idGame,
                   name: game.name,
                   released: dateFormatter.date(from: game.released!),
                   description: "",
                   rating: game.rating,
                   backgroundImage: URL(string: game.backgroundImage ?? "")!,
                   genres: game.genres,
                   platforms: [],
                   publishers: [],
                   metacritic: 0)
    }

    static func mapGameEntityToGameUIModel(game: GameEntity) -> GameUIModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: game.released.map { dateFormatter.string(from: $0) } ?? "",
                           description: game.description,
                           rating: String(game.rating),
                           backgroundImage: game.backgroundImage!.absoluteString,
                           genres: Formatter.formatGenre(from: game.genres!),
                           platforms: game.platforms,
                           publishers: game.publishers,
                           metacritic: game.metacritic)
    }

    static func mapGameResponseToGameUIModel(game: GameResponse) -> GameUIModel {
        return GameUIModel(idGame: game.idGame,
                           name: game.name,
                           released: Formatter.formatDate(from: game.released),
                           description: "",
                           rating: String(game.rating),
                           backgroundImage: game.backgroundImage,
                           genres: Formatter.formatGenre(from: game.genres!),
                           platforms: [],
                           publishers: [],
                           metacritic: 0)
    }

}
