import Foundation
import Alamofire
import Combine

protocol Networking {
    func request(_ url: URL) -> AnyPublisher<Data, Error>
}

class AlamofireNetworking: Networking {
    func request(_ url: URL) -> AnyPublisher<Data, Error> {
        return Future { promise in
            AF.request(url)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
}

public class RAWGClient {
    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

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

public class RAWGClient1 {
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
                // Debug print to ensure data is received
                print(String(data: data, encoding: .utf8) ?? "No data")
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
