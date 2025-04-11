//
//  GetPhotosUseCase.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

protocol GetPhotosUseCase {
    func execute(completion: @escaping ([Photo]) -> Void)
}

class GetPhotosUseCaseImpl: GetPhotosUseCase {
    private let repository: PhotoRepository
    init(repository: PhotoRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping ([Photo]) -> Void) {
        repository.getPhotos(completion: completion)
    }
}
