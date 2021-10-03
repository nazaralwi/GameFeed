import Foundation

struct Genre: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}
