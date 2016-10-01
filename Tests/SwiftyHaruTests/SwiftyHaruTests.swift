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
    
    private var _recordMode = false
    
    override var recordMode: Bool {
        get {
            return _recordMode
        }
        set {
            _recordMode = newValue
        }
    }
    
    var sut: PDFDocument!
    
    override func setUp() {
        super.setUp()
        
        sut = PDFDocument()
    }
    
    override func tearDown() {
        
        saveReferenceFileIfNeeded(sut.getData(), ofType: "pdf")
        
        super.tearDown()
    }
    
    func testCreateEmptyDocument() {
        
        recordMode = false
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")!
        
        // When
        sut.addPage(size: .a4, direction: .portrait)
        sut.addPage(size: .a4, direction: .landscape)
        sut.addPage(size: .a4, direction: .portrait)
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
