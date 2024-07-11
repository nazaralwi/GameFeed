import Foundation

struct GameResult: Codable {
    let results: [Game]
}

struct Game: Codable {
    let idGame: Int
    let name: String
    let released: String?
    let rating: Double
    let backgroundImage: String?
    let genres: [Genre]?

    enum CodingKeys: String, CodingKey {
        case idGame = "id"
        case name
        case released
        case rating
        case backgroundImage = "background_image"
        case genres
    }
}

struct Genre: Codable {
    let name: String
}

struct GameFavoriteViewModel {
    let idGame: Int
    let name: String
    let released: String
    let rating: String
    let backgroundImage: String
    let genres: String
}
