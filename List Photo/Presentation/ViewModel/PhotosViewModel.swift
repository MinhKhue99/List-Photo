//
//  PhotosViewModel.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

import Foundation

class PhotosViewModel {
    private let getPhotosUseCase: GetPhotosUseCase

    init(getPhotosUseCase: GetPhotosUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
    }

    var photos: [Photo] = []
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?

    func getPhotos() {
        getPhotosUseCase.execute { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                Logger.shared.debugPrint("Photo count: \(photos.count)")
                self?.onUpdate?()

            case .failure(let error):
                self?.onError?(error)
            }
        }
    }

    func search(query: String) {
        if query.isEmpty {
            photos
        } else {
            photos.filter { photo in
                photo.author.lowercased().contains(query.lowercased()) ||
                photo.id.lowercased().contains(query.lowercased())
            }
        }
        onUpdate?()
    }
}
