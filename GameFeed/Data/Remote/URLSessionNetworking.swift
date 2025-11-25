//
//  URLSessionNetworking.swift
//  GameFeed
//
//  Created by Macintosh on 11/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine

public enum NetworkError: Error {
    case invalidResponse
    case httpStatus(Int)
    case emptyData
}

public protocol Networking {
    func request(_ url: URL) -> AnyPublisher<Data, Error>
}

public final class URLSessionNetworking: Networking {
    public func request(_ url: URL) -> AnyPublisher<Data, any Error> {
        return Future { promise in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let httpResponse = (response as? HTTPURLResponse) else {
                    promise(.failure(NetworkError.invalidResponse))
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(NetworkError.httpStatus(httpResponse.statusCode)))
                    return
                }

                guard let data = data else {
                    promise(.failure(NetworkError.emptyData))
                    return
                }

                promise(.success(data))
            }.resume()
        }.eraseToAnyPublisher()
    }
}
