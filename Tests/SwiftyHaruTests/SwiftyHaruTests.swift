//
//  TestHelpers.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import XCTest
import SwiftyHaru

class SwiftyHaruTests: XCTestCase {

    static var allTests : [(String, (SwiftyHaruTests) -> () throws -> Void)] {
        return [
            ("testCreateEmptyDocument", testCreateEmptyDocument)
        ]
    }
    
    func testCreateEmptyDocument() {
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: "Empty", ofType: "pdf")
        
        // When
        let pdf = PDFDocument()
        pdf.addPage(size: .a4, direction: .portrait)
        pdf.addPage(size: .a4, direction: .landscape)
        pdf.addPage(size: .a4, direction: .portrait)
        let returnedDocumentData = pdf.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
