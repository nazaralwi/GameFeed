import Foundation

enum Endpoints {
    static let base = "https://api.rawg.io/api/games"
    case getGameList
    case backgroundImageURL(String)
    case search(String)
    case getGameDetail(Int)
    case getNewGameLastMonts(String, String)
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
    var stringValue: String {
        switch self {
        case .getGameList:
            return Endpoints.base
        case .backgroundImageURL(let backgroundPath):
            return backgroundPath
        case .search(let query):
            return Endpoints.base +
                "?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .getGameDetail(let idGame):
            return Endpoints.base + "/\(String(idGame))"
        case .getNewGameLastMonts(let startDate, let endDate):
            return Endpoints.base + "?dates=\(startDate),\(endDate)&&ordering=added"
        }
    }
}
