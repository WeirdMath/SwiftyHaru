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
    
    static let allTests = [
        ("testGetSetWidth", testGetSetWidth),
        ("testGetSetHeight", testGetSetHeight),
        ("testRotatePage", testRotatePage),
        ("testDrawObject", testDrawObject)
    ]

    func testGetSetWidth() {

        // Given
        let sut = document.addPage()
        XCTAssertEqual(sut.width, PDFPage.defaultWidth, accuracy: 1.0)
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
        let sut = document.addPage()
        XCTAssertEqual(sut.height, PDFPage.defaultHeight, accuracy: 1.0)
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
        let page0 = document.addPage()
        let page1 = document.addPage()
        let page2 = document.addPage()
        
        // When
        page0.rotate(byAngle: 90)
        page1.rotate(byAngle: 810)
        page2.rotate(byAngle: -270)

        // Then
        assertPDFSnapshot()
    }
    
    func testDrawObject() throws {
        
        // Given
        final class DrawableObject: Drawable {
            
            func draw(in context: DrawingContext, position: Point) {
                context.fillColor = .red
                let path = Path().appendingCircle(center: position, radius: 100)
                context.fill(path)
            }
        }
        
        // When
        let object = DrawableObject()
        try document.addPage { context in
            try context.draw(object, x: 300, y: 300)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
}
