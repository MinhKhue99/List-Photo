//
//  MockPhotosViewModelDelegate.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import UIKit
@testable import List_Photo

class MockPhotosViewModelDelegate: PhotosViewModelDelegate {
    var didLoadInitialPhotosCalled = false
    var didLoadMorePhotosCalled = false
    var didChangeLoadingStateCalls: [Bool] = []
    var didFailWithErrorCalled = false
    var lastError: Error?
    var lastNewIndexPaths: [IndexPath] = []

    func didLoadInitialPhotos() {
        didLoadInitialPhotosCalled = true
    }

    func didLoadMorePhotos(newIndexPaths: [IndexPath]) {
        didLoadMorePhotosCalled = true
        lastNewIndexPaths = newIndexPaths
    }

    func didChangeLoadingState(isLoading: Bool) {
        didChangeLoadingStateCalls.append(isLoading)
    }
    
    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        lastError = error
    }
}
