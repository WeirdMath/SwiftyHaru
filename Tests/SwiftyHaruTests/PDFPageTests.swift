//
//  PDFPageTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import XCTest
import SwiftyHaru

class PDFPageTests: XCTestCase {
    
    static var allTests : [(String, (PDFPageTests) -> () throws -> Void)] {
        return [
            ("testGetSetWidth", testGetSetWidth),
            ("testGetSetHeight", testGetSetHeight),
            ("testRotatePage", testRotatePage),
        ]
    }
    
    var recordMode = false
    
    var sut: PDFPage!
    
    var document: PDFDocument!
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        
        document = PDFDocument()
        sut = document.addPage()
    }
    
    override func tearDown() {
        
        if recordMode {
            saveReferenceFile(document.getData(), ofType: "pdf")
        }
        
        document = nil
        
        super.tearDown()
    }
    
    func testGetSetWidth() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let expectedWidth: Float = 1000
        
        // When
        sut.width = 1000
        let returnedWidth = sut.width
        
        // Then
        XCTAssertEqual(expectedWidth, returnedWidth)
        
        // When
        sut.width = 2
        let returnedWidthTooSmall = sut.width
        
        // Then
        XCTAssertEqual(expectedWidth, returnedWidthTooSmall,
                       "Setting too small width should make no change")
        
        // When
        sut.width = 14401
        let returnedWidthTooBig = sut.width
        
        // Then
        XCTAssertEqual(expectedWidth, returnedWidthTooBig,
                       "Setting too big width should make no change")
        
        // When
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testGetSetHeight() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let expectedHeight: Float = 2000
        
        // When
        sut.height = 2000
        let returnedHeight = sut.height
        
        // Then
        XCTAssertEqual(expectedHeight, returnedHeight)
        
        // When
        sut.height = 2
        let returnedHeightTooSmall = sut.height
        
        // Then
        XCTAssertEqual(expectedHeight, returnedHeightTooSmall,
                       "Setting too small width should make no change")
        
        // When
        sut.height = 14401
        let returnedHeightTooBig = sut.height
        
        // Then
        XCTAssertEqual(expectedHeight, returnedHeightTooBig,
                       "Setting too big width should make no change")
        
        // When
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testRotatePage() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let page0 = sut!
        let page1 = document.addPage()
        let page2 = document.addPage()
        let page3 = document.addPage()
        
        // When
        try! page0.rotate(byAngle: 90)
        try! page1.rotate(byAngle: 810)
        try! page2.rotate(byAngle: -270)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
        
        XCTAssertThrowsError(try page3.rotate(byAngle: 45))
    }
}
