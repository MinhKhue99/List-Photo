//
//  PhotoRepository.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

protocol PhotoRepository {
    func getPhotos(page: Int, limit: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
}
