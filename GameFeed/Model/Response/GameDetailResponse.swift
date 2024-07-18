import Foundation

struct GameDetailResponse: Codable {
    let idGame: Int
    let name: String
    let released: String?
    let description: String?
    let rating: Double?
    let backgroundImage: String?
    let genres: [GenreResponse]?
    let platforms: [PlatformsResponse]
    let publishers: [PublisherResponse]
    let metacritic: Int?

    enum CodingKeys: String, CodingKey {
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

struct PublisherResponse: Codable {
    let name: String
}

struct PlatformsResponse: Codable {
    let platform: PlatformResponse
    let releasedAt: String

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
    }
}

struct PlatformResponse: Codable {
    let name: String
    let slug: String
}
