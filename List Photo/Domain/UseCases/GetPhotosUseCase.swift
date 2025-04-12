//
//  GetPhotosUseCase.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

protocol GetPhotosUseCase {
    func execute(completion: @escaping (Result<[Photo], Error>) -> Void)
}

class GetPhotosUseCaseImpl: GetPhotosUseCase {
    private let repository: PhotoRepository
    init(repository: PhotoRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[Photo], Error>) -> Void) {
        repository.getPhotos(completion: completion)
    }
}
