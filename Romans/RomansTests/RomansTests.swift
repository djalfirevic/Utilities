//
//  RomansTests.swift
//  RomansTests
//
//  Created by Djuro on 10/16/20.
//

import XCTest
@testable import Romans

final class RomansTests: XCTestCase {
    
    // MARK: - Properties
    let solution = Solution()
    
    // MARK: - Dictionary Tests
    func test5() {
        XCTAssertEqual(solution.solve(5), "V")
    }
    
    func test1990() {
        XCTAssertEqual(solution.solve(1990), "MCMXC")
    }
    
    func test2008() {
        XCTAssertEqual(solution.solve(2008), "MMVIII")
    }
    
    func test99() {
        XCTAssertEqual(solution.solve(99), "XCIX")
    }
    
    func test47() {
        XCTAssertEqual(solution.solve(47), "XLVII")
    }
    
    // MARK: - Prime Number Tests
    func testP0() {
        XCTAssertEqual(solution.biggestPrimeNumber(from: 0), nil)
    }
    
    func testP5() {
        XCTAssertEqual(solution.biggestPrimeNumber(from: 5), 5)
    }
    
    func testP1990() {
        XCTAssertTrue(solution.biggestPrimeNumber(from: 1990) == 1000, "It should be 1000")
    }
    
    func testP2008() {
        XCTAssertTrue(solution.biggestPrimeNumber(from: 2008) == 1000, "It should be 2000")
    }
    
    func testP99() {
        XCTAssertTrue(solution.biggestPrimeNumber(from: 99) == 90, "It should be 90")
    }
    
    func testP47() {
        XCTAssertTrue(solution.biggestPrimeNumber(from: 47) == 40, "It should be 40")
    }
    
}
