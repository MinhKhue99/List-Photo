//
//  PicsumClient.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

import Foundation

struct PicsumClient {

    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoDTO], Error>) -> Void) {
        let endpoint = PicsumEndpoint(page: page, limit: limit)

        apiService.request(endpoint) { (result: Result<[PhotoDTO], Error>) in
            switch result {
            case .success(let photos):
                Logger.shared.debugPrint("photos: \(photos)", function: "getPhotos")
                completion(.success(photos))
            case .failure(let error):
                Logger.shared.debugPrint("error: \(error)", function: "getPhotos")
                completion(.failure(error))
            }
        }
    }
}
