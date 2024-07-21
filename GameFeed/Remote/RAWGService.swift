import Foundation
import Alamofire
import Combine

public class RAWGService {
    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getGameList() -> AnyPublisher<[GameUIModel], Error> {
        guard let gameListURL = Endpoints.getGameList.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameListURL, response: GameResultResponse.self)
            .map { $0.results.map { GameMapper.mapGameResponseToGameUIModel(game: $0) } }
            .eraseToAnyPublisher()
    }

    func search(query: String) -> AnyPublisher<[GameUIModel], Error> {
        guard let gameSearchURL = Endpoints.search(query).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameSearchURL, response: GameResultResponse.self)
            .map { $0.results.map { GameMapper.mapGameResponseToGameUIModel(game: $0) } }
            .eraseToAnyPublisher()
    }

    func getGameDetail(idGame: Int) -> AnyPublisher<GameUIModel, Error> {
        guard let gameDetailURL = Endpoints.getGameDetail(idGame).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameDetailURL, response: GameDetailResponse.self)
            .map { GameMapper.mapGameDetailResponseToGameUIModel(game: $0) }
            .eraseToAnyPublisher()
    }

    func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[GameUIModel], Error> {
        guard let gameLastMonthsURL = Endpoints.getNewGameLastMonts(lastMonth, now).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        print(gameLastMonthsURL)
        return taskForGETRequest(url: gameLastMonthsURL, response: GameResultResponse.self)
            .map { $0.results.map { GameMapper.mapGameResponseToGameUIModel(game: $0) } }
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

    func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        guard let gameBackgroundURL = Endpoints.backgroundImageURL(backgroundPath).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return networking.request(gameBackgroundURL)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
