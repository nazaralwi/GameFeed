import Foundation
import Combine

public class GameRemoteDataSource: GameRemoteDataSourceProtocol {
    private let networking: Networking

    public init(networking: Networking) {
        self.networking = networking
    }

    public func getGameList() async throws -> [GameModel] {
        guard let gameListURL = Endpoints.getGameList.url else {
            throw NetworkError.badUrl
        }

        let result = try await taskForGETRequest(url: gameListURL, response: GameResultResponse.self)

        return result.results.map {
            GameMapper.mapGameResponseToGameModel(game: $0)
        }
    }

    public func search(query: String) async throws -> [GameModel] {
        guard let gameListURL = Endpoints.getGameList.url else {
            throw NetworkError.badUrl
        }

        let result = try await taskForGETRequest(url: gameListURL, response: GameResultResponse.self)

        return result.results.map {
            GameMapper.mapGameResponseToGameModel(game: $0)
        }
    }

    public func getGameDetail(idGame: Int) async throws -> GameModel {
        guard let gameDetailURL = Endpoints.getGameDetail(idGame).url else {
            throw NetworkError.badUrl
        }

        let result = try await taskForGETRequest(url: gameDetailURL, response: GameDetailResponse.self)

        return GameMapper.mapGameDetailResponseToGameModel(game: result)
    }

    public func getNewGameLastMonths(lastMonth: String, now: String) async throws -> [GameModel] {
        guard let gameLastMonthsURL = Endpoints.getNewGameLastMonts(lastMonth, now).url else {
            throw NetworkError.badUrl
        }

        let result = try await taskForGETRequest(url: gameLastMonthsURL, response: GameResultResponse.self)

        return result.results.map {
            GameMapper.mapGameResponseToGameModel(game: $0)
        }
    }

    public func downloadBackground(backgroundPath: String) async throws -> Data {
        guard let gameBackgroundURL = Endpoints.backgroundImageURL(backgroundPath).url else {
            throw NetworkError.badUrl
        }

        return try await networking.request(gameBackgroundURL)
    }

    private func taskForGETRequest
                <ResponseType: Decodable>(
                    url: URL,
                    response: ResponseType.Type
                ) async throws -> ResponseType {
        let data = try await networking.request(url)
        return try JSONDecoder().decode(ResponseType.self, from: data)
    }
}
