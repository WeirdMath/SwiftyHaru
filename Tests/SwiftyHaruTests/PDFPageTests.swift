//
//  PDFPageTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import XCTest
import SnapshotTesting
import SwiftyHaru

final class PDFPageTests: TestCase {
    
    static var allTests : [(String, (PDFPageTests) -> () throws -> Void)] {
        return [
            ("testGetSetWidth", testGetSetWidth),
            ("testGetSetHeight", testGetSetHeight),
            ("testRotatePage", testRotatePage),
            ("testDrawObject", testDrawObject)
        ]
    }

    var sut: PDFPage!
    
    override func setUp() {
        super.setUp()
        
        record = false
        
        sut = document.addPage()
    }

    func testGetSetWidth() {
        
        // Given
        let expectedWidth: Float = 1000
        
        // When
        sut.width = 1000
        let returnedWidth = sut.width
        
        // Then
        XCTAssertEqual(expectedWidth, returnedWidth)
        assertPDFSnapshot()
    }
    
    func testGetSetHeight() {

        // Given
        let expectedHeight: Float = 2000
        
        // When
        sut.height = 2000
        let returnedHeight = sut.height
        
        // Then
        XCTAssertEqual(expectedHeight, returnedHeight)
        assertPDFSnapshot()
    }
    
    func testRotatePage() {

        // Given
        let page0 = sut!
        let page1 = document.addPage()
        let page2 = document.addPage()
        
        // When
        page0.rotate(byAngle: 90)
        page1.rotate(byAngle: 810)
        page2.rotate(byAngle: -270)

        // Then
        assertPDFSnapshot()
    }
    
    func testDrawObject() {
        
        // Given
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

        // Then
        assertPDFSnapshot()
    }
}
