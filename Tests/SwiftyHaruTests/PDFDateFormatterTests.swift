//
//  PDFDateFormatterTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 06.06.2017.
//
//

import Foundation
import XCTest
import SwiftyHaru

class PDFDateFormatterTests: XCTestCase {

    var sut: PDFDateFormatter!

    static var allTests: [(String, (PDFDateFormatterTests) -> () throws -> Void)] {
        return [
            ("testConvertDateToString", testConvertDateToString),
            ("testConvertStringToDate", testConvertStringToDate)
        ]
    }

    override func setUp() {
        super.setUp()

        sut = PDFDateFormatter()
    }

    func testConvertDateToString() {

        // Given
        let timeZone1 = TimeZone(secondsFromGMT: -28_800)!
        let date1 = DateComponents(calendar: Calendar(identifier: .gregorian),
                                   timeZone: timeZone1,
                                   year: 1998,
                                   month: 12,
                                   day: 23,
                                   hour: 19,
                                   minute: 52,
                                   second: 5).date!
        let expectedString1 = "D:19981223195205-08'00'"

        let timeZone2 = TimeZone(secondsFromGMT: 18_000)!
        let date2 = DateComponents(calendar: Calendar(identifier: .gregorian),
                                   timeZone: timeZone2,
                                   year: 2017,
                                   month: 3,
                                   day: 27,
                                   hour: 18,
                                   minute: 32,
                                   second: 30).date!
        let expectedString2 = "D:20170327183230+05'00'"

        let timeZone3 = TimeZone(secondsFromGMT: 0)!
        let date3 = DateComponents(calendar: Calendar(identifier: .gregorian),
                                   timeZone: timeZone3,
                                   year: 2018,
                                   month: 5,
                                   day: 1,
                                   hour: 0,
                                   minute: 0,
                                   second: 1).date!
        let expectedString3 = "D:20180501000001Z"

        // When
        let returnedString1 = sut.string(from: date1, timeZone: timeZone1)
        let returnedString2 = sut.string(from: date2, timeZone: timeZone2)
        let returnedString3 = sut.string(from: date3, timeZone: timeZone3)

        // Then
        XCTAssertEqual(expectedString1, returnedString1)
        XCTAssertEqual(expectedString2, returnedString2)
        XCTAssertEqual(expectedString3, returnedString3)
    }

    func testConvertStringToDate() {

        // Given
        let string1 = "D:19981223195205-08'00'"
        let expectedTimeZone1 = TimeZone(secondsFromGMT: -28_800)!
        let expectedDate1 = DateComponents(calendar: Calendar(identifier: .gregorian),
                                           timeZone: expectedTimeZone1,
                                           year: 1998,
                                           month: 12,
                                           day: 23,
                                           hour: 19,
                                           minute: 52,
                                           second: 5).date!

        let string2 = "D:20170327183230+05'00'"
        let expectedTimeZone2 = TimeZone(secondsFromGMT: 18_000)!
        let expectedDate2 = DateComponents(calendar: Calendar(identifier: .gregorian),
                                           timeZone: expectedTimeZone2,
                                           year: 2017,
                                           month: 3,
                                           day: 27,
                                           hour: 18,
                                           minute: 32,
                                           second: 30).date!

        let string3 = "D:20180501000001Z"
        let expectedTimeZone3 = TimeZone(secondsFromGMT: 0)!
        let expectedDate3 = DateComponents(calendar: Calendar(identifier: .gregorian),
                                           timeZone: expectedTimeZone3,
                                           year: 2018,
                                           month: 5,
                                           day: 1,
                                           hour: 0,
                                           minute: 0,
                                           second: 1).date!

        let string4 = "D:20170327183230+05'af'"

        // When
        let returnedDate1 = sut.date(from: string1)
        let returnedDate2 = sut.date(from: string2)
        let returnedDate3 = sut.date(from: string3)
        let returnedDate4 = sut.date(from: string4)


        // Then
        XCTAssertEqual(expectedDate1, returnedDate1)
        XCTAssertEqual(expectedDate2, returnedDate2)
        XCTAssertEqual(expectedDate3, returnedDate3)
        XCTAssertNil(returnedDate4)
    }
}
