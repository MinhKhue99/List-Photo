//
//  GetPhotosUseCase.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

protocol GetPhotosUseCase {
    func execute(page: Int, limit: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}

class GetPhotosUseCaseImpl: GetPhotosUseCase {
    private let repository: PhotoRepository
    init(repository: PhotoRepository) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int = 100, completion: @escaping (Result<[Photo], Error>) -> Void) {
        repository.getPhotos(page: page, limit: limit, completion: completion)
    }
}
