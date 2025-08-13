import Foundation

public enum Endpoints {
    private static let base = "https://api.rawg.io/api/games"

    case getGameList
    case backgroundImageURL(String)
    case search(String)
    case getGameDetail(Int)
    case getNewGameLastMonts(String, String)

    public var url: URL? {
        guard let urlString = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }

    private static var apiKey: String = {
        guard let filePath = Bundle.main.path(forResource: "RAWG-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'RAWG-Info.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'RAWG-Info.plist'.")
        }

        if value.starts(with: "_") {
            fatalError("Register for a RAWG developer account and get an API key at "
                       + "https://rawg.io/login?forward=developer")
        }
        return value
    }()

    private var stringValue: String {
        switch self {
        case .getGameList:
            return Endpoints.base + "?key=\(Endpoints.apiKey)"
        case .backgroundImageURL(let backgroundPath):
            return backgroundPath
        case .search(let query):
            let queryWithEncoding = query.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed) ?? ""
            return Endpoints.base +
                "?search=\(queryWithEncoding)&key=\(Endpoints.apiKey)"
        case .getGameDetail(let idGame):
            return Endpoints.base + "/\(String(idGame))?key=\(Endpoints.apiKey)"
        case .getNewGameLastMonts(let startDate, let endDate):
            return Endpoints.base + "?dates=\(startDate),\(endDate)&&ordering=added&key=\(Endpoints.apiKey)"
        }
    }
}
