//
//  Endpoints.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 07/10/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

enum Endpoints {
    static let base = "https://api.rawg.io/api/games"
    
    case getGameList
    case backgroundImageURL(String)
    case search(String)
    case getGameDetail(Int)
    
    var url: URL {
        return URL(string: stringValue)!
    }
    
    var stringValue: String {
        switch self {
        case .getGameList:
            return Endpoints.base + "?page_size=100"
        case .backgroundImageURL(let backgroundPath):
            return backgroundPath
        case .search(let query):
            return Endpoints.base + "/games?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .getGameDetail(let id):
            return Endpoints.base + String(id)
        }
    }
}
