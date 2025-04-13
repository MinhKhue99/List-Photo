//
//  PicsumClientTests.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import XCTest
@testable import List_Photo

final class PicsumClientTests: XCTestCase {

    func testGetPhotosSuccess() {
        let mockService = MockAPIService()
        let expectedPhotos = [
            PhotoDTO(id: "1", author: "John", width: 300, height: 200, download_url: "")
        ]
        mockService.mockPhotos = expectedPhotos
        let client = PicsumClient(apiService: mockService)

        let expectation = self.expectation(description: "Fetch photos")

        client.getPhotos(page: 1, limit: 10) { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, expectedPhotos.count)
                XCTAssertEqual(photos.first?.id, expectedPhotos.first?.id)
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testGetPhotosFailure() {
        let mockService = MockAPIService()
        mockService.shouldReturnError = true
        let client = PicsumClient(apiService: mockService)

        let expectation = self.expectation(description: "Fetch photos failure")

        client.getPhotos(page: 1, limit: 10) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).localizedDescription, "Mock error")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
