import Foundation
import Alamofire
import Combine

public class RAWGService {
    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getGameList() -> AnyPublisher<[Game], Error> {
        guard let gameListURL = Endpoints.getGameList.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameListURL, response: GameResult.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    func search(query: String) -> AnyPublisher<[Game], Error> {
        guard let gameSearchURL = Endpoints.search(query).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameSearchURL, response: GameResult.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    func getGameDetail(idGame: Int) -> AnyPublisher<GameDetail, Error> {
        guard let gameDetailURL = Endpoints.getGameDetail(idGame).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameDetailURL, response: GameDetail.self)
            .eraseToAnyPublisher()
    }

    func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[Game], Error> {
        guard let gameLastMonthsURL = Endpoints.getNewGameLastMonts(lastMonth, now).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameLastMonthsURL, response: GameResult.self)
            .map { $0.results }
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
