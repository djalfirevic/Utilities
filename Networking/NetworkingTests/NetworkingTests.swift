//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Djuro on 12/13/20.
//

import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    
    // MARK: - Properties
    private let dataManager = DataManager(api: MockAPI())
    
    // MARK: - Tests
    func test_ShouldGetPosts_When_FetchPostsIsSuccessful() {
        let requestExpectation = expectation(description: "Request Expectation")
        
        dataManager.fetchPosts({ result in
            requestExpectation.fulfill()
            
            switch result {
            case .success(let posts):
                XCTAssertNotNil(posts, "There should be some posts.")
            case .failure(_):
                XCTFail("There should be some posts.")
            }
        })
        
        waitForExpectations(timeout: 5, handler: { (error) in
            if error != nil {
                XCTFail("Request timed out")
            }
        })
    }
    
}
