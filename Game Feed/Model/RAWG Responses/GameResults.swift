import Foundation

struct GameResult: Codable {
    let count: Int
    let next: String
    let results: [Game]
}
