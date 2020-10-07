import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
    let slug: String
    let gameCount: Int
    let imageBackground: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case gameCount = "games_count"
        case imageBackground = "image_background"
    }
}
