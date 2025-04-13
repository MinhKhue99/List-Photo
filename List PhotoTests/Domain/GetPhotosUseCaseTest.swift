//
//  GetPhotosUseCaseTest.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import XCTest
@testable import List_Photo

class GetPhotosUseCaseTest: XCTestCase {
    var useCase: GetPhotosUseCaseImpl!
    var mockRepository: MockPhotoRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockPhotoRepository()
        useCase = GetPhotosUseCaseImpl(repository: mockRepository)
    }

    func testExecute_Success() {
        // Arrange
        let expectedPhotos = [
            Photo(id: "1", author: "John", width: 5000, height: 3333, downloadURL: "url1"),
            Photo(id: "2", author: "Jane", width: 5000, height: 3333, downloadURL: "url2")
        ]
        mockRepository.mockResult = .success(expectedPhotos)
        let expectation = self.expectation(description: "Photos fetched")

        // Act
        useCase.execute(page: 1, limit: 10) { result in
            // Assert
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, expectedPhotos.count, "Photo array counts should match")
                for (actual, expected) in zip(photos, expectedPhotos) {
                    XCTAssertEqual(actual.id, expected.id, "Photo IDs should match")
                    XCTAssertEqual(actual.author, expected.author, "Photo authors should match")
                    XCTAssertEqual(actual.downloadURL, expected.downloadURL, "Photo image URLs should match")
                }
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
