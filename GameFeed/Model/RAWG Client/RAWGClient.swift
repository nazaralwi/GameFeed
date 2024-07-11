import Foundation
import Alamofire
import Combine

public class RAWGClient {
    private static let session = Alamofire.Session.default
    private static let decoder = JSONDecoder()

    static func getGameList() -> AnyPublisher<[Game], Error> {
        guard let gameListURL = Endpoints.getGameList.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameListURL, response: GameResult.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    static func search(query: String) -> AnyPublisher<[Game], Error> {
        guard let gameSearchURL = Endpoints.search(query).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameSearchURL, response: GameResult.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    static func getGameDetail(idGame: Int) -> AnyPublisher<GameDetail, Error> {
        guard let gameDetailURL = Endpoints.getGameDetail(idGame).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameDetailURL, response: GameDetail.self)
            .eraseToAnyPublisher()
    }

    static func getNewGameLastMonths(lastMonth: String, now: String) -> AnyPublisher<[Game], Error> {
        guard let gameLastMonthsURL = Endpoints.getNewGameLastMonts(lastMonth, now).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return taskForGETRequest(url: gameLastMonthsURL, response: GameResult.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    private static func taskForGETRequest
                <ResponseType: Decodable>(
                    url: URL,
                    response: ResponseType.Type
                ) -> AnyPublisher<ResponseType, Error> {
        return Future { promise in
            session
                .request(url)
                .validate()
                .responseDecodable(of: response) { response in
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    static func downloadBackground(backgroundPath: String) -> AnyPublisher<Data, Error> {
        guard let gameBackgroundURL = Endpoints.backgroundImageURL(backgroundPath).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return Future { promise in
            session
                .request(gameBackgroundURL)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
