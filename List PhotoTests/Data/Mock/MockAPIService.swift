//
//  MockAPIService.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import Foundation
@testable import List_Photo

class MockAPIService: APIService {
    var shouldReturnError = false
    var mockPhotos: [PhotoDTO] = []

    override func request<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "com.test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
            completion(.failure(error))
        } else {
            // Make sure the mockPhotos can be cast to the expected type T
            if let result = mockPhotos as? T {
                completion(.success(result))
            } else {
                fatalError("Type mismatch. Check that T == [PhotoDTO].")
            }
        }
    }
}
