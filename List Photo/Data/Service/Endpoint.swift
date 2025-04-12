//
//  Endpoint.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethods { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var urlRequest: URLRequest? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

struct PicsumEndpoint: Endpoint {
    var baseURL: String { "https://picsum.photos" }
    var path: String { "/v2/list" }

    let page: Int
    let limit: Int

    var method: HTTPMethods { .get }

    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
    }
}
