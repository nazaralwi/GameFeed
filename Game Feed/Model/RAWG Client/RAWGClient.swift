//
//  RAWG Client.swift
//  Game Feed
//
//  Created by M Nazar Alwi on 15/09/20.
//  Copyright © 2020 Dicoding Indonesia. All rights reserved.
//

import Foundation

class RAWGClient {
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    class func getGameList(completion: @escaping ([Game], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getGameList.url, response: GameResult.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func search(query: String, completion: @escaping ([Game], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.search(query).url, response: GameResult.self) { (response, error) in
            if let response = response {
                completion(response.results, error)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getGameDetail(id: Int, completion: @escaping (GameDetail?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getGameDetail(id).url, response: GameDetail.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
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
