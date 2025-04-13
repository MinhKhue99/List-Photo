//
//  PicsumEndpointTests.swift
//  List PhotoTests
//
//  Created by KhuePM on 13/4/25.
//

import XCTest
@testable import List_Photo

class PicsumEndpointTests: XCTestCase {
    var endpoint: PicsumEndpoint!

    override func setUp() {
        super.setUp()
        endpoint = PicsumEndpoint(page: 1, limit: 10)
    }

    override func tearDown() {
        endpoint = nil
        super.tearDown()
    }

    func testBaseURL_IsCorrect() {
        // Assert
        XCTAssertEqual(endpoint.baseURL, "https://picsum.photos", "Base URL should match")
    }

    func testPath_IsCorrect() {
        // Assert
        XCTAssertEqual(endpoint.path, "/v2/list", "Path should match")
    }

    func testMethod_IsGet() {
        // Assert
        XCTAssertEqual(endpoint.method, .get, "Method should be GET")
        XCTAssertEqual(endpoint.method.rawValue, "GET", "Raw method should be GET")
    }

    func testQueryItems_ContainsPageAndLimit() {
        // Arrange
        let expectedQueryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "10")
        ]

        // Act
        let queryItems = endpoint.queryItems

        // Assert
        XCTAssertEqual(queryItems?.count, 2, "Should have two query items")
        XCTAssertTrue(
            queryItems?.contains { $0.name == "page" && $0.value == "1" } == true,
            "Should contain page=1"
        )
        XCTAssertTrue(
            queryItems?.contains { $0.name == "limit" && $0.value == "10" } == true,
            "Should contain limit=10"
        )
        XCTAssertEqual(queryItems, expectedQueryItems, "Query items should match")
    }

    func testURLRequest_FormsCorrectURL() {
        // Act
        let urlRequest = endpoint.urlRequest

        // Assert
        XCTAssertNotNil(urlRequest, "URLRequest should not be nil")
        XCTAssertEqual(
            urlRequest?.url?.absoluteString,
            "https://picsum.photos/v2/list?page=1&limit=10",
            "URL should include base, path, and query items"
        )
        XCTAssertEqual(urlRequest?.httpMethod, "GET", "HTTP method should be GET")
    }

    func testURLRequest_DifferentPageAndLimit() {
        // Arrange
        endpoint = PicsumEndpoint(page: 2, limit: 20)

        // Act
        let urlRequest = endpoint.urlRequest

        // Assert
        XCTAssertEqual(
            urlRequest?.url?.absoluteString,
            "https://picsum.photos/v2/list?page=2&limit=20",
            "URL should reflect updated page and limit"
        )
    }

    func testURLRequest_ZeroPageAndLimit() {
        // Arrange
        endpoint = PicsumEndpoint(page: 0, limit: 0)

        // Act
        let urlRequest = endpoint.urlRequest

        // Assert
        XCTAssertEqual(
            urlRequest?.url?.absoluteString,
            "https://picsum.photos/v2/list?page=0&limit=0",
            "URL should handle zero values"
        )
    }
}
