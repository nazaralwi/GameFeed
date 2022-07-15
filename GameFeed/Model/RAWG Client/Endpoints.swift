import Foundation

enum Endpoints {
    static let key = "2d318da4043d4db9bcbe0ec84c6c44bd"
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
            return Endpoints.base + "?key=\(Endpoints.key)"
        case .backgroundImageURL(let backgroundPath):
            return backgroundPath
        case .search(let query):
            return Endpoints.base +
                "?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&key=\(Endpoints.key)"
        case .getGameDetail(let idGame):
            return Endpoints.base + "/\(String(idGame))?key=\(Endpoints.key)"
        case .getNewGameLastMonts(let startDate, let endDate):
            return Endpoints.base + "?dates=\(startDate),\(endDate)&&ordering=added?key=\(Endpoints.key)"
        }
    }
}
