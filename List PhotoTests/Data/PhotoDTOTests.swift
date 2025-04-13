//
//  PhotoDTOTests.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import XCTest
@testable import List_Photo

final class PhotoDTOTests: XCTestCase {

    func test_toDomain_shouldMapAllFieldsCorrectly() {
        // Given
        let dto = PhotoDTO(
            id: "1",
            author: "John",
            width: 800,
            height: 600,
            download_url: "url1"
        )

        let expected = Photo(
            id: "1",
            author: "John",
            width: 800,
            height: 600,
            downloadURL: "url1"
        )

        // When
        let actual = dto.toDomain()

        // Then
        XCTAssertEqual(actual.id, expected.id, "ID should be mapped correctly")
        XCTAssertEqual(actual.author, expected.author, "Author should be mapped correctly")
        XCTAssertEqual(actual.width, expected.width, "Width should be mapped correctly")
        XCTAssertEqual(actual.height, expected.height, "Height should be mapped correctly")
        XCTAssertEqual(actual.downloadURL, expected.downloadURL, "Download URL should be mapped correctly")
    }

    func test_toDomain_withEmptyAuthor_shouldStillMapCorrectly() {
        // Given
        let dto = PhotoDTO(
            id: "1",
            author: "",
            width: 800,
            height: 600,
            download_url: "url1"
        )

        // When
        let actual = dto.toDomain()

        // Then
        XCTAssertEqual(actual.author, "", "Empty author should be preserved")
    }
}
