//
//  RAWG Client.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 15/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

class RAWGClient {
    enum Endpoints {
        static let base = "https://api.rawg.io/api"
        
        case getGameList
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .getGameList: return Endpoints.base + "/games"
            }
        }
    }
    
    class func getGameList(completion: @escaping ([Game], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getGameList.url) { (data, response, error) in
            guard let data = data else {
                completion([], error)
                print(error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GameResult.self, from: data)
                completion(responseObject.results, nil)
                print(responseObject)
            } catch {
                completion([], error)
                print(error)
            }
        }
        task.resume()
    }
}
