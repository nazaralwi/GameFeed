import Foundation

public struct GameResultResponse: Codable {
    public let results: [GameResponse]
}

public struct GameResponse: Codable {
    public let idGame: Int
    public let name: String
    public let released: String?
    public let rating: Double
    public let backgroundImagePath: String?
    public let genres: [GenreResponse]?

    private enum CodingKeys: String, CodingKey {
        case idGame = "id"
        case name
        case released
        case rating
        case backgroundImagePath = "background_image"
        case genres
    }
}

public struct GenreResponse: Codable {
    public let name: String
}
