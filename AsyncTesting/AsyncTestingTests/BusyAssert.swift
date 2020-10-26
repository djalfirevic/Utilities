//
//  BusyAssert.swift
//  AsyncTestingTests
//
//  Created by Djuro Alfirevic on 3/2/20.
//  Copyright © 2020 Djuro Alfirevic. All rights reserved.
//

import XCTest

extension XCTest {
    
    func expectToEventually(
        _ isFulfilled: @autoclosure () -> Bool,
        timeout: TimeInterval,
        message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        func wait() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01)) }
        
        let timeout = Date(timeIntervalSinceNow: timeout)
        func isTimeout() -> Bool { Date() >= timeout }

        repeat {
            if isFulfilled() { return }
            wait()
        } while !isTimeout()
        
        XCTFail(message, file: file, line: line)
    }
    
    func expect(
        _ isFulfilled: @autoclosure () -> Bool,
        for duration: TimeInterval,
        message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        func wait() { RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01)) }
        
        let timeout = Date(timeIntervalSinceNow: duration)
        func isTimeout() -> Bool { Date() >= timeout }
        
        repeat {
            if !isFulfilled() {
                XCTFail(message, file: file, line: line)
                return
            }
            wait()
        } while !isTimeout()
    }
    
}
