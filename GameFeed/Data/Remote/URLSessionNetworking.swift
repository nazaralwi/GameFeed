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
    case badUrl
}

public protocol Networking {
    func request(_ url: URL) async throws -> Data
}

public final class URLSessionNetworking: Networking {
    public func request(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
