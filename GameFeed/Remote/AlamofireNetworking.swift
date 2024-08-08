//
//  AlamofireNetworking.swift
//  GameFeed
//
//  Created by Macintosh on 11/07/24.
//  Copyright © 2024 Dicoding Indonesia. All rights reserved.
//

import Foundation
import Combine
import Alamofire

public protocol Networking {
    func request(_ url: URL) -> AnyPublisher<Data, Error>
}

public final class AlamofireNetworking: Networking {
    public func request(_ url: URL) -> AnyPublisher<Data, Error> {
        return Future { promise in
            AF.request(url)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(data))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
}
