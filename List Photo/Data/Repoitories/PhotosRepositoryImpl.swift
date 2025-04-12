//
//  PhotosRepositoryImpl.swift
//  List Photo
//
//  Created by KhuePM on 12/4/25.
//

class PhotosRepositoryImpl: PhotoRepository {

    private let picsumClient: PicsumClient
    init(picsumClient: PicsumClient) {
        self.picsumClient = picsumClient
    }

    func getPhotos(completion: @escaping (Result<[Photo], any Error>) -> Void) {
        picsumClient.getPhotos {result in
            switch result {
            case .success(let dtos):
                let photos = dtos.map { $0.toDomain() }
                completion(.success(photos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
