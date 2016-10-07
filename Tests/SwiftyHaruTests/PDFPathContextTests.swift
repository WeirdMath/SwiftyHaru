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
            ("testPathDashStyle", testPathDashStyle),
            ("testPathLineCap", testPathLineCap),
            ("testPathLineJoin", testPathLineJoin),
            ("testStrokeColorRGB", testStrokeColorRGB),
            ("testStrokeColorCMYK", testStrokeColorCMYK),
            ("testStrokeColorGray", testStrokeColorGray),
            ("testFillColorRGB", testFillColorRGB),
            ("testFillColorCMYK", testFillColorCMYK),
            ("testFillColorGray", testFillColorGray),
            ("testPathMoveDrawingPoint", testPathMoveDrawingPoint),
            ("testDrawPathWithoutPainting", testDrawPathWithoutPainting),
            ("testConstructPath", testConstructPath),
            ("testPaintPath", testPaintPath)
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
    
    // MARK: - Graphics state
    
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
    
    func testPathDashStyle() {
        
        // Given
        let expectedInitialDashStyle = DashStyle.straightLine
        let expectedDashStyle1 = DashStyle(pattern: [10, 5], phase: 3)!
        let expectedDashStyle2 = DashStyle(pattern: [], phase: 0)!
        let expectedFinalDashStyle = expectedInitialDashStyle
        
        // When
        var returnedInitialDashStyle: DashStyle?
        page.drawPath { context in
            returnedInitialDashStyle = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedInitialDashStyle, returnedInitialDashStyle)
        
        // When
        var returnedDashStyle1: DashStyle?
        page.drawPath { context in
            context.dashStyle = DashStyle(pattern: [10, 5], phase: 3)!
            returnedDashStyle1 = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedDashStyle1, returnedDashStyle1)
        
        // When
        var returnedDashStyle2: DashStyle?
        page.drawPath { context in
            context.dashStyle = DashStyle(pattern: [], phase: 10)!
            returnedDashStyle2 = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedDashStyle2, returnedDashStyle2)
        
        // When
        var returnedFinalDashStyle: DashStyle?
        page.drawPath { context in
            returnedFinalDashStyle = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedFinalDashStyle, returnedFinalDashStyle)
    }
    
    func testPathLineCap() {
        
        // Given
        let expectedInitialLineCap = LineCap.butt
        let expectedLineCap = LineCap.round
        let expectedFinalLineCap = expectedInitialLineCap
        
        // When
        var returnedInitialLineCap: LineCap?
        page.drawPath { context in
            returnedInitialLineCap = context.lineCap
        }
        
        // Then
        XCTAssertEqual(expectedInitialLineCap, returnedInitialLineCap)
        
        // When
        var returnedLineCap: LineCap?
        page.drawPath { context in
            context.lineCap = .round
            returnedLineCap = context.lineCap
        }
        
        // Then
        XCTAssertEqual(expectedLineCap, returnedLineCap)
        
        // When
        var returnedFinalLineCap: LineCap?
        page.drawPath { context in
            returnedFinalLineCap = context.lineCap
        }
        
        // Then
        XCTAssertEqual(expectedFinalLineCap, returnedFinalLineCap)
    }
    
    func testPathLineJoin() {
        
        // Given
        let expectedInitialLineJoin = LineJoin.miter
        let expectedLineJoin = LineJoin.round
        let expectedFinalLineJoin = expectedInitialLineJoin
        
        // When
        var returnedInitialLineJoin: LineJoin?
        page.drawPath { context in
            returnedInitialLineJoin = context.lineJoin
        }
        
        // Then
        XCTAssertEqual(expectedInitialLineJoin, returnedInitialLineJoin)
        
        // When
        var returnedLineJoin: LineJoin?
        page.drawPath { context in
            context.lineJoin = .round
            returnedLineJoin = context.lineJoin
        }
        
        // Then
        XCTAssertEqual(expectedLineJoin, returnedLineJoin)
        
        // When
        var returnedFinalLineJoin: LineJoin?
        page.drawPath { context in
            returnedFinalLineJoin = context.lineJoin
        }
        
        // Then
        XCTAssertEqual(expectedFinalLineJoin, returnedFinalLineJoin)
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
    
    // MARK: - Path construction
    
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
    
    private func constructUnclosedCurve(in context: PDFPathContext, startingWith point: Point) {
        context.move(to: point)
        context.line(to: point + Vector(x: 37.5, y: -25))
        context.curve(controlPoint1: point + Vector(x: 75, y: 0),
                      controlPoint2: point + Vector(x: 75, y: 137.5),
                      endPoint: point + Vector(x: 50, y: 125))
        context.curve(controlPoint1: point + Vector(x: 25, y: 112.5),
                      controlPoint2: point + Vector(x: 12.5, y: 12.5),
                      endPoint: point + Vector(x: 62.5, y: 12.5))
        context.curve(controlPoint1: point + Vector(x: 87.5, y: 12.5),
                      controlPoint2: point + Vector(x: 100, y: 25),
                      endPoint: point + Vector(x: 100, y: 0))
        context.curve(controlPoint1: point + Vector(x: 100, y: -25),
                      controlPoint2: point + Vector(x: 50, y: -25),
                      endPoint: point + Vector(x: 25, y: 0))
        context.curve(controlPoint1: point + Vector(x: 0, y: 25),
                      controlPoint2: point + Vector(x: -25, y: 75),
                      endPoint: point + Vector(x: 37.5, y: 87.5))
        context.curve(controlPoint1: point + Vector(x: 100, y: 100),
                      controlPoint2: point + Vector(x: 100, y: -12.5),
                      endPoint: point + Vector(x: 25, y: -50))
    }
    
    // MARK: - Path paiting
    
    func testPaintPath() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        
        // Draw some simple paths
        
        page.drawPath { context in
            
            context.lineWidth = 3
            context.move(toX: 100, y: 100)
            context.line(toX: 500, y: 100)
            context.strokeColor = .red
            context.strokePath()
            
            context.lineWidth = 5
            context.move(toX: 100, y: 150)
            context.line(toX: 500, y: 150)
            context.line(toX: 500, y: 200)
            context.line(toX: 100, y: 200)
            context.fillColor = .blue
            context.fillPath(stroke: true)
        }
        
        // Filling using even-odd rule with stroking
        
        page.drawPath { context in
            XCTAssertEqual(context.currentPosition, Point.zero)
            XCTAssertEqual(context.lineWidth, 1)
            XCTAssertEqual(context.strokeColor, .black)
            XCTAssertEqual(context.fillColor, .black)
            
            constructUnclosedCurve(in: context, startingWith: Point(x: 100, y: 300))
            context.closePath()
            
            context.fillColor = .green
            context.fillPath(evenOddRule: true, stroke: true)
        }
        
        // Filling using nonzero winding number rule with stroking
        
        page.drawPath { context in

            constructUnclosedCurve(in: context, startingWith: Point(x: 225, y: 300))
            context.closePath()
            
            context.fillColor = .green
            context.fillPath(evenOddRule: false, stroke: true)
        }
        
        // Filling using even-odd number rule without stroking
        
        page.drawPath { context in
            
            constructUnclosedCurve(in: context, startingWith: Point(x: 100, y: 500))
            context.closePath()
            
            context.fillColor = .green
            context.fillPath(evenOddRule: true, stroke: false)
        }
        
        // Filling using nonzero winding number rule without stroking
        
        page.drawPath { context in
            
            constructUnclosedCurve(in: context, startingWith: Point(x: 225, y: 500))
            context.closePath()
            
            context.fillColor = .green
            context.fillPath(evenOddRule: false, stroke: false)
        }
        
        // Closing path with filling using even-odd rule
        
        page.drawPath { context in

            context.fillColor = .blue
            context.lineWidth = 5
            
            constructUnclosedCurve(in: context, startingWith: Point(x: 100, y: 700))
            
            context.closePathFillStroke(evenOddRule: true)
        }
        
        // Closing path with filling using nonzero winding number rule
        
        page.drawPath { context in
            
            context.fillColor = .blue
            context.lineWidth = 5
            
            constructUnclosedCurve(in: context, startingWith: Point(x: 225, y: 700))
            
            context.closePathFillStroke(evenOddRule: false)
        }
        
        // Closing path with stroking
        
        page.drawPath { context in
            
            context.move(toX: 400, y: 250)
            context.line(toX: 400, y: 600)
            context.line(toX: 500, y: 600)
            
            context.closePathStroke()
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
