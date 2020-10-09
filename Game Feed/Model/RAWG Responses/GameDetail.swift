import Foundation

struct GameDetail: Codable {
    let id: Int
    let name: String
    let released: String?
    let description: String
    let rating: Double
    let backgroundImage: String?
    let genres: [Genre]?
    let platforms: [Platforms]
    let publishers: [Publisher]
    let metacritic: Int
    
    enum CodingKeys: String, CodingKey {
        case id
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
    
    init() {
        id = 0
        name = ""
        released = ""
        description = ""
        rating = 0
        backgroundImage = nil
        genres = []
        platforms = []
        publishers = []
        metacritic = 0
    }
}
