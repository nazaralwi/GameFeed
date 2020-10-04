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
        case backgroundImageURL(String)
        case search(String)
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .getGameList: return Endpoints.base + "/games"
            case .backgroundImageURL(let backgroundPath): return backgroundPath
            case .search(let query): return Endpoints.base + "/games?search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            }
        }
    }
    
    class func getGameList(completion: @escaping ([Game], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getGameList.url) { (data, response, error) in
            guard let data = data else {
                completion([], error)
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
    
    class func search(query: String, completion: @escaping ([Game], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.search(query).url) { (data, response, error) in
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GameResult.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        
        task.resume()
    }
    
    class func downloadBackground(backgroundPath: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.backgroundImageURL(backgroundPath).url) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
}
