//
//  Endpoint.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

import Foundation

enum HTTPMethods: String {
    case GET, POST, PUT, DELETE
}

enum NetworkError: Error {
    case network(Error)
    case invalidResponse
    case noData
    case decoding(Error)
}

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "picsum.photos"
        components.path = "/v2" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            fatalError("Failed to construct URL from components: \(components)")
        }
        return url
    }
}

enum PicsumEndpoint: Endpoint {
    case list(page: Int, limit: Int)

    var path: String {
        switch self {
        case .list:
            return "/list"
        }
    }

    var method: String { HTTPMethods.GET.rawValue }

    var headers: [String: String] { [:] }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let page, let limit):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        }
    }

    var body: Data? { nil }
}
