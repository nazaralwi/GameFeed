import Foundation
import Combine

public class GameRemoteDataSource: GameRemoteDataSourceProtocol {
    private let networking: Networking

    public init(networking: Networking) {
        self.networking = networking
    }

    public func getGameList() -> AnyPublisher<[GameModel], Error> {
        guard let gameListURL = Endpoints.getGameList.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameListURL, response: GameResultResponse.self)
            .map { $0.results.map { GameMapper.mapGameResponseToGameModel(game: $0) } }
            .eraseToAnyPublisher()
    }

    public func search(query: String) -> AnyPublisher<[GameModel], Error> {
        guard let gameSearchURL = Endpoints.search(query).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameSearchURL, response: GameResultResponse.self)
            .map { $0.results.map { GameMapper.mapGameResponseToGameModel(game: $0) } }
            .eraseToAnyPublisher()
    }

    public func getGameDetail(idGame: Int) -> AnyPublisher<GameModel, Error> {
        guard let gameDetailURL = Endpoints.getGameDetail(idGame).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameDetailURL, response: GameDetailResponse.self)
            .map { GameMapper.mapGameDetailResponseToGameModel(game: $0) }
            .eraseToAnyPublisher()
    }

    public func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameModel], Error> {
        guard let gameLastMonthsURL = Endpoints.getNewGameLastMonts(lastMonth, now).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        print(gameLastMonthsURL)
        return taskForGETRequest(url: gameLastMonthsURL, response: GameResultResponse.self)
            .map { $0.results.map { GameMapper.mapGameResponseToGameModel(game: $0) } }
            .eraseToAnyPublisher()
    }

    public func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        guard let gameBackgroundURL = Endpoints.backgroundImageURL(backgroundPath).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return networking.request(gameBackgroundURL)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func taskForGETRequest
                <ResponseType: Decodable>(
                    url: URL,
                    response: ResponseType.Type
                ) -> AnyPublisher<ResponseType, Error> {
        return networking.request(url)
            .tryMap { data in
                return try JSONDecoder().decode(ResponseType.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
