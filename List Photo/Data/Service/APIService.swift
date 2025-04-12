//
//  APIService.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: any Endpoint, completion: @escaping (Result<T, any Error>) -> Void)
}

class APIService: NetworkService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func request<T: Decodable>(_ endpoint: any Endpoint, completion: @escaping (Result<T, any Error>) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.dataNotAllowed)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
