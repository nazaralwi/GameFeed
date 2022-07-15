import Foundation

public class RAWGClient {
    @discardableResult class func taskForGETRequest
        <ResponseType: Decodable>(url: URL,
                                  response: ResponseType.Type,
                                  completion: @escaping (ResponseType?, Error?)
        -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
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
    
    class func search(query: String, completion: @escaping ([Game], Error?) -> Void) -> URLSessionTask {
        let task = taskForGETRequest(url: Endpoints.search(query).url, response: GameResult.self) { (response, error) in
            if let response = response {
                completion(response.results, error)
            } else {
                completion([], error)            }
        }
        return task
    }
    
    class func getGameDetail(idGame: Int, completion: @escaping (GameDetail?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getGameDetail(idGame).url, response: GameDetail.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getNewGameLastMonts(lastMonth: String, now: String, completion: @escaping ([Game], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getNewGameLastMonts(lastMonth, now).url,
                          response: GameResult.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func downloadBackground(backgroundPath: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared
            .dataTask(with: Endpoints.backgroundImageURL(backgroundPath).url) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
}
