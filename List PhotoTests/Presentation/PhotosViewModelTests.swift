//
//  List_PhotoTests.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import XCTest
@testable import List_Photo

final class PhotosViewModelTests: XCTestCase {
    func testLoadInitialPhotosSuccess() {
           let mockUseCase = MockGetPhotosUseCase()
           mockUseCase.mockResult = .success([Photo(id: "1", author: "Author 1",width: 5000, height: 3333, downloadURL: "")])

           let viewModel = PhotosViewModel(getPhotosUseCase: mockUseCase)
           let delegate = MockPhotosViewModelDelegate()
           viewModel.delegate = delegate

           let expectation = self.expectation(description: "Wait for async load")
           viewModel.loadInitialPhotos()

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               XCTAssertTrue(delegate.didLoadInitialPhotosCalled)
               XCTAssertEqual(delegate.didChangeLoadingStateCalls, [true, true, false, false])
               XCTAssertFalse(delegate.didFailWithErrorCalled)
               XCTAssertEqual(viewModel.photos.count, 1)
               expectation.fulfill()
           }

           waitForExpectations(timeout: 1, handler: nil)
       }

       func testLoadInitialPhotosFailure() {
           let mockUseCase = MockGetPhotosUseCase()
           mockUseCase.mockResult = .failure(NSError(domain: "Test", code: 0))

           let viewModel = PhotosViewModel(getPhotosUseCase: mockUseCase)
           let delegate = MockPhotosViewModelDelegate()
           viewModel.delegate = delegate

           let expectation = self.expectation(description: "Wait for error")
           viewModel.loadInitialPhotos()

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
               XCTAssertTrue(delegate.didFailWithErrorCalled)
               XCTAssertEqual(delegate.didChangeLoadingStateCalls, [true, true, false, false])
               XCTAssertFalse(delegate.didLoadInitialPhotosCalled)
               expectation.fulfill()
           }

           waitForExpectations(timeout: 1, handler: nil)
       }

       func testSearchWithEmptyQuery() {
           let mockUseCase = MockGetPhotosUseCase()
           let viewModel = PhotosViewModel(getPhotosUseCase: mockUseCase)
           let delegate = MockPhotosViewModelDelegate()
           viewModel.delegate = delegate

           viewModel.search(query: "   ")

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               XCTAssertTrue(delegate.didFailWithErrorCalled)
               XCTAssertEqual(delegate.didChangeLoadingStateCalls.last, false)
           }
       }

       func testLoadMorePhotosSuccess() {
           let mockUseCase = MockGetPhotosUseCase()
           mockUseCase.mockResult = .success([Photo(id: "1", author: "Author 1",width: 5000, height: 3333, downloadURL: "")])

           let viewModel = PhotosViewModel(getPhotosUseCase: mockUseCase)
           let delegate = MockPhotosViewModelDelegate()
           viewModel.delegate = delegate
           viewModel.loadInitialPhotos()

           let expectation = self.expectation(description: "Wait for load more")

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
               viewModel.loadMorePhotos()
           }

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               XCTAssertTrue(delegate.didLoadMorePhotosCalled)
               XCTAssertFalse(delegate.lastNewIndexPaths.isEmpty)
               XCTAssertEqual(delegate.didChangeLoadingStateCalls.last, false)
               expectation.fulfill()
           }

           waitForExpectations(timeout: 1, handler: nil)
       }
}
