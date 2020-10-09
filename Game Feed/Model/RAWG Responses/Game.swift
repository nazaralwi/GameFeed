import Foundation

struct Game: Codable {
    let id: Int
    let name: String
    let released: String?
    let rating: Double
    let backgroundImage: String?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case rating
        case backgroundImage = "background_image"
        case genres
    }
}
