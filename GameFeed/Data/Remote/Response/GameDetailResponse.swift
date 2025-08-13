import Foundation

public struct GameDetailResponse: Codable {
    public let idGame: Int
    public let name: String
    public let released: String?
    public let description: String?
    public let rating: Double?
    public let backgroundImage: String?
    public let genres: [GenreResponse]?
    public let platforms: [PlatformsResponse]?
    public let publishers: [PublisherResponse]?
    public let metacritic: Int?

    private enum CodingKeys: String, CodingKey {
        case idGame = "id"
        case name
        case released
        case description = "description_raw"
        case rating
        case backgroundImage = "background_image"
        case genres
        case platforms
        case publishers
        case metacritic
    }
}

public struct PublisherResponse: Codable {
    public let name: String
}

public struct PlatformsResponse: Codable {
    public let platform: PlatformResponse
    public let releasedAt: String

    private enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
    }
}

public struct PlatformResponse: Codable {
    public let name: String
    public let slug: String
}
