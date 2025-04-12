//
//  PhotoDTO.swift
//  List Photo
//
//  Created by KhuePM on 11/4/25.
//

struct PhotoDTO: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let download_url: String
}
