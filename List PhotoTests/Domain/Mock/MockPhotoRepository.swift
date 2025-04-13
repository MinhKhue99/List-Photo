//
//  MockPhotoRepository.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

@testable import List_Photo

class MockPhotoRepository: PhotoRepository {
    var mockResult: Result<[List_Photo.Photo], Error>?
    func getPhotos(page: Int, limit: Int, completion: @escaping (Result<[List_Photo.Photo], Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
