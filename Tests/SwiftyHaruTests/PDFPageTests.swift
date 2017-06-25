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
            ("testDrawObject", testDrawObject)
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
        
        // When
        page0.rotate(byAngle: 90)
        page1.rotate(byAngle: 810)
        page2.rotate(byAngle: -270)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testDrawObject() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        class DrawableObject: Drawable {
            
            func draw(in context: DrawingContext, position: Point) {
                context.fillColor = .red
                let path = Path().appendingCircle(center: position, radius: 100)
                context.fill(path)
            }
        }
        
        // When
        let object = DrawableObject()
        sut.draw(object: object, x: 300, y: 300)
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
