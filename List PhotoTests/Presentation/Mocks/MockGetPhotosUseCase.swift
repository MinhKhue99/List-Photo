//
//  MockGetPhotosUseCase.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//
import Foundation
@testable import List_Photo

class MockGetPhotosUseCase: GetPhotosUseCase {
    var mockResult: Result<[List_Photo.Photo], Error> = .success([])
    func execute(page: Int, limit: Int, completion: @escaping (Result<[List_Photo.Photo], any Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                        completion(self.mockResult)
                    }
    }
}
