//
//  PhotoMapper.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

import Foundation

extension PhotoDTO {
    func toDomain() -> Photo {
        Photo(id: id, author: author, width: width, height: height, downloadURL: download_url)
    }
}
