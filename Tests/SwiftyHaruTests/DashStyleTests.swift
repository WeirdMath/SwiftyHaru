//
//  DashStyleTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 06.10.16.
//
//

import XCTest
import SwiftyHaru

final class DashStyleTests: TestCase {
    
    static let allTests = [
        ("testPattern", testPattern),
    ]

    func testPattern() {
        
        // Given
        let validPattern1 = [Int]()
        let validPattern2 = [6]
        let validPattern3 = [12, 4, 5, 100]
        let invalidPattern1 = [-1, 2]
        let invalidPattern2 = [70000, 12]
        let invalidPattern3 = [12, 4, 5]
        let invalidPattern4 = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        // When
        let initializedStyle1 = DashStyle(pattern: validPattern1)
        let initializedStyle2 = DashStyle(pattern: validPattern2)
        let initializedStyle3 = DashStyle(pattern: validPattern3)
        let initializedStyle4 = DashStyle(pattern: validPattern3, phase: 10)
        let uninitializedStyle1 = DashStyle(pattern: invalidPattern1)
        let uninitializedStyle2 = DashStyle(pattern: invalidPattern2)
        let uninitializedStyle3 = DashStyle(pattern: invalidPattern3)
        let uninitializedStyle4 = DashStyle(pattern: invalidPattern4)
        let uninitializedStyle5 = DashStyle(pattern: validPattern3, phase: -1)
        
        // Then
        XCTAssertNotNil(initializedStyle1)
        XCTAssertNotNil(initializedStyle2)
        XCTAssertNotNil(initializedStyle3)
        XCTAssertNotNil(initializedStyle4)
        XCTAssertNil(uninitializedStyle1)
        XCTAssertNil(uninitializedStyle2)
        XCTAssertNil(uninitializedStyle3)
        XCTAssertNil(uninitializedStyle4)
        XCTAssertNil(uninitializedStyle5)
    }
}
