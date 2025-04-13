//
//  PhotoDTOTests.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import XCTest
@testable import List_Photo

class PhotoDTOTests: XCTestCase {
    func testToDomain_MapsCorrectly() {
        // Arrange
        let dto = PhotoDTO(id: "1", author: "John", width: 800, height: 600, download_url: "url1")
        let expectedPhoto = Photo(id: "1", author: "John", width: 800, height: 600, downloadURL: "url1")

        // Act
        let photo = dto.toDomain()

        // Assert
        XCTAssertEqual(photo.id, expectedPhoto.id, "IDs should match")
        XCTAssertEqual(photo.author, expectedPhoto.author, "Authors should match")
        XCTAssertEqual(photo.width, expectedPhoto.width, "Widths should match")
        XCTAssertEqual(photo.height, expectedPhoto.height, "Heights should match")
        XCTAssertEqual(photo.downloadURL, expectedPhoto.downloadURL, "Download URLs should match")
    }

    func testToDomain_EmptyAuthor_StillMaps() {
        // Arrange
        let dto = PhotoDTO(id: "1", author: "", width: 800, height: 600, download_url: "url1")
        let expectedPhoto = Photo(id: "1", author: "", width: 800, height: 600, downloadURL: "url1")

        // Act
        let photo = dto.toDomain()

        // Assert
        XCTAssertEqual(photo.author, "", "Empty author should map")
    }
}
