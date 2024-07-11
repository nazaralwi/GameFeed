import Foundation

struct Platforms: Codable {
    let platform: Platform
    let releasedAt: String

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
    }
}
