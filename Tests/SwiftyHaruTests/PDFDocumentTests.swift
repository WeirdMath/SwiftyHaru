//
//  PDFDocumentTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import XCTest
import SwiftyHaru

class PDFDocumentTests: XCTestCase {
    
    static var allTests : [(String, (PDFDocumentTests) -> () throws -> Void)] {
        return [
            ("testCreateEmptyDocument", testCreateEmptyDocument),
            ("testAddingPages", testAddingPages)
        ]
    }
    
    var recordMode = false
    
    var sut: PDFDocument!
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        
        sut = PDFDocument()
    }
    
    override func tearDown() {
        
        if recordMode {
            saveReferenceFile(sut.getData(), ofType: "pdf")
        }
        
        super.tearDown()
    }
    
    func testCreateEmptyDocument() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testAddingPages() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        sut.addPage()
        sut.addPage(width: 100, height: 100)
        sut.addPage(size: .a4, direction: .landscape)
        sut.insertPage(atIndex: 3)
        sut.insertPage(size: .a3, direction: .portrait, atIndex: 0)
        sut.insertPage(width: 30, height: 30, atIndex: 2)
        
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testPageLayout() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let expectedPageLayout = PDFDocument.PageLayout.twoColumnRight
        
        // When
        sut.addPage()
        sut.addPage()
        sut.addPage()
        sut.addPage()
        
        // Then
        XCTAssertEqual(.default, sut.pageLayout)
        
        // When
        sut.pageLayout = .twoColumnRight
        let returnedPageLayout = sut.pageLayout
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedPageLayout, returnedPageLayout)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
