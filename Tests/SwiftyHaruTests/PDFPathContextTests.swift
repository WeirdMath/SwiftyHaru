//
//  PDFPathContextTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 05.10.16.
//
//

import XCTest
import SwiftyHaru

class PDFPathContextTests: XCTestCase {
    
    static var allTests : [(String, (PDFPathContextTests) -> () throws -> Void)] {
        return [
            ("testPathLineWidth", testPathLineWidth),
            ("testPathMoveDrawingPoint", testPathMoveDrawingPoint),
            ("testStrokeColorRGB", testStrokeColorRGB),
            ("testStrokeColorCMYK", testStrokeColorCMYK),
            ("testStrokeColorGray", testStrokeColorGray),
            ("testFillColorRGB", testFillColorRGB),
            ("testFillColorCMYK", testFillColorCMYK),
            ("testFillColorGray", testFillColorGray),
            ("testDrawPathWithoutPainting", testDrawPathWithoutPainting),
            ("testConstructPath", testConstructPath)
        ]
    }
    
    var recordMode = false
    
    var page: PDFPage!
    
    var document: PDFDocument!
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        
        document = PDFDocument()
        page = document.addPage()
    }
    
    override func tearDown() {
        
        if recordMode {
            saveReferenceFile(document.getData(), ofType: "pdf")
        }
        
        document = nil
        
        super.tearDown()
    }
    
    func testPathLineWidth() {
        
        // Given
        let expectedInitialLineWidth: Float = 1
        let expectedLineWidth: Float = 10
        let expectedFinalLineWidth = expectedInitialLineWidth
        
        // When
        var returnedInitialLineWidth: Float = -1
        page.drawPath { context in
            returnedInitialLineWidth = context.lineWidth
        }
        
        // Then
        XCTAssertEqual(expectedInitialLineWidth, returnedInitialLineWidth)
        
        // When
        var returnedLineWidth: Float = -1
        page.drawPath { context in
            context.lineWidth = 10
            returnedLineWidth = context.lineWidth
        }
        
        // Then
        XCTAssertEqual(expectedLineWidth, returnedLineWidth)
        
        // When
        var returnedFinalLineWidth: Float = -1
        page.drawPath { context in
            returnedFinalLineWidth = context.lineWidth
        }
        
        // Then
        XCTAssertEqual(expectedFinalLineWidth, returnedFinalLineWidth)
    }
    
    func testPathMoveDrawingPoint() {
        
        // Given
        let expectedInitialPoint = Point(x: 0, y: 0)
        let expectedPoint = Point(x: 10, y: 20)
        let expectedFinalPoint = expectedInitialPoint
        
        // When
        var returnedInitialPoint = Point(x: -1000, y: -1000)
        page.drawPath { context in
            returnedInitialPoint = context.currentPosition
        }
        
        // Then
        XCTAssertEqual(expectedInitialPoint, returnedInitialPoint)
        
        // When
        var returnedPoint = Point(x: -1000, y: -1000)
        page.drawPath { context in
            context.move(to: Point(x: 10, y: 20))
            returnedPoint = context.currentPosition
        }
        
        // Then
        XCTAssertEqual(expectedPoint, returnedPoint)
        
        // When
        var returnedFinalPoint = Point(x: -1000, y: -1000)
        page.drawPath { context in
            returnedFinalPoint = context.currentPosition
        }
        
        // Then
        XCTAssertEqual(expectedFinalPoint, returnedFinalPoint)
    }
    
    func testStrokeColorRGB() {
        
        // Given
        let expectedStrokeColor = Color(red: 0.1, green: 0.3, blue: 0.5)!
        let expectedColorSpace = PDFColorSpace.deviceRGB
        
        // When
        var returnedStrokeColor = Color(red: 0, green: 0, blue: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.drawPath { context in
            context.strokeColor = expectedStrokeColor
            returnedStrokeColor = context.strokeColor
            returnedColorSpace = context.strokingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedStrokeColor, returnedStrokeColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testStrokeColorCMYK() {
        
        // Given
        let expectedStrokeColor = Color(cyan: 0.1, magenta: 0.3, yellow: 0.5, black: 0.7)!
        let expectedColorSpace = PDFColorSpace.deviceCMYK
        
        // When
        var returnedStrokeColor = Color(cyan: 0, magenta: 0, yellow: 0, black: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.drawPath { context in
            context.strokeColor = expectedStrokeColor
            returnedStrokeColor = context.strokeColor
            returnedColorSpace = context.strokingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedStrokeColor, returnedStrokeColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testStrokeColorGray() {
        
        // Given
        let expectedStrokeColor = Color(gray: 0.7)!
        let expectedColorSpace = PDFColorSpace.deviceGray
        
        // When
        var returnedStrokeColor = Color(gray: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.drawPath { context in
            context.strokeColor = expectedStrokeColor
            returnedStrokeColor = context.strokeColor
            returnedColorSpace = context.strokingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedStrokeColor, returnedStrokeColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testFillColorRGB() {
        
        // Given
        let expectedFillColor = Color(red: 0.1, green: 0.3, blue: 0.5)!
        let expectedColorSpace = PDFColorSpace.deviceRGB
        
        // When
        var returnedFillColor = Color(red: 0, green: 0, blue: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.drawPath { context in
            context.fillColor = expectedFillColor
            returnedFillColor = context.fillColor
            returnedColorSpace = context.fillingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedFillColor, returnedFillColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testFillColorCMYK() {
        
        // Given
        let expectedFillColor = Color(cyan: 0.1, magenta: 0.3, yellow: 0.5, black: 0.7)!
        let expectedColorSpace = PDFColorSpace.deviceCMYK
        
        // When
        var returnedFillColor = Color(cyan: 0, magenta: 0, yellow: 0, black: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.drawPath { context in
            context.fillColor = expectedFillColor
            returnedFillColor = context.fillColor
            returnedColorSpace = context.fillingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedFillColor, returnedFillColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testFillColorGray() {
        
        // Given
        let expectedFillColor = Color(gray: 0.7)!
        let expectedColorSpace = PDFColorSpace.deviceGray
        
        // When
        var returnedFillColor = Color(gray: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.drawPath { context in
            context.fillColor = expectedFillColor
            returnedFillColor = context.fillColor
            returnedColorSpace = context.fillingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedFillColor, returnedFillColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testDrawPathWithoutPainting() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let expectedPositionAfterAddingLine1 = Point(x: 10, y: 10)
        let expectedPositionAfterEndingPath = Point(x: 10, y: 20)
        
        // When
        var returnedPositionAfterAddingLine1 = Point.zero
        var returnedPositionAfterEndingPath = Point.zero
        page.drawPath { context in
            context.move(to: .zero)
            context.line(to: Point(x: 10, y: 10))
            returnedPositionAfterAddingLine1 = context.currentPosition
            context.line(to: Point(x: 10, y: 20))
            context.endPath()
            returnedPositionAfterEndingPath = context.currentPosition
        }
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedPositionAfterAddingLine1, returnedPositionAfterAddingLine1)
        XCTAssertEqual(expectedPositionAfterEndingPath, returnedPositionAfterEndingPath)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testConstructPath() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        page.drawPath { context in
            
            context.move(toX: 100, y: 100)
            context.line(toX: 400, y: 100)
            context.move(toX: 500, y: 200)
            context.arc(x: 400, y: 200, radius: 100, beginningAngle: 90, endAngle: 180)
            context.move(toX: 500, y: 200)
            context.circle(x: 200, y: 200, radius: 50)
            context.move(toX: 500, y: 200)
            context.rectangle(x: 300, y: 200, width: 50, height: 100)
            context.move(toX: 500, y: 200)
            context.ellipse(x: 200, y: 200, horizontalRadius: 50, verticalRadius: 25)
            context.ellipse(inscribedIn: Rectangle(x: 300, y: 200, width: 50, height: 100))
            context.move(toX: 500, y: 200)
            context.curve(controlPoint1: Point(x: 400, y: 200),
                          controlPoint2: Point(x: 400, y: 300),
                          endPoint: Point(x: 500, y: 300))
            context.curve(controlPoint2: Point(x: 400, y: 400), endPoint: Point(x: 500, y: 400))
            context.curve(controlPoint1: Point(x: 400, y: 400), endPoint: Point(x: 500, y: 500))
            
            context.closePath()
            XCTAssertEqual(Point(x: 500, y: 200), context.currentPosition,
                           "After closing a subpath the current point should be set to the start of the subpath")
            
            context.circle(x: 200, y: 200, radius: 75)
            context.rectangle(x: 325, y: 150, width: 50, height: 100)
            context.ellipse(x: 200, y: 200, horizontalRadius: 40, verticalRadius: 20)
            
            context.strokePath()
        }
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
