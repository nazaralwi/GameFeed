import Foundation

struct GameResultResponse: Codable {
    let results: [GameResponse]
}

struct GameResponse: Codable {
    let idGame: Int
    let name: String
    let released: String?
    let rating: Double
    let backgroundImage: String?
    let genres: [GenreResponse]?

    enum CodingKeys: String, CodingKey {
        case idGame = "id"
        case name
        case released
        case rating
        case backgroundImage = "background_image"
        case genres
    }
}

struct GenreResponse: Codable {
    let name: String
}
