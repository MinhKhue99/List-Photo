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

    func getPhotos(completion: @escaping (Result<[PhotoDTO], Error>) -> Void) {
        apiService.request(PicsumEndpoint.list(page: 1, limit: 100)) { (result: Result<[PhotoDTO], Error>) in
            switch result {
            case .success(let photos):
                Logger.shared.debugPrint("photos: \(photos)", fuction: "getPhotos")
                completion(.success(photos))
            case .failure(let error):
                Logger.shared.debugPrint("error: \(error)", fuction: "getPhotos")
                completion(.failure(error))
            }
        }
    }
}
