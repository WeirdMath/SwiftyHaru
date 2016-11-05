//
//  DrawingContextTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 05.10.16.
//
//

import XCTest
import SwiftyHaru

class DrawingContextTests: XCTestCase {
    
    static var allTests : [(String, (DrawingContextTests) -> () throws -> Void)] {
        return [
            ("testPathLineWidth", testPathLineWidth),
            ("testPathDashStyle", testPathDashStyle),
            ("testPathLineCap", testPathLineCap),
            ("testPathLineJoin", testPathLineJoin),
            ("testPathMiterLimit", testPathMiterLimit),
            ("testStrokeColorRGB", testStrokeColorRGB),
            ("testStrokeColorCMYK", testStrokeColorCMYK),
            ("testStrokeColorGray", testStrokeColorGray),
            ("testFillColorRGB", testFillColorRGB),
            ("testFillColorCMYK", testFillColorCMYK),
            ("testFillColorGray", testFillColorGray),
            ("testConstructPath", testConstructPath),
            ("testPaintPath", testPaintPath),
            ("testClipToPathNonzeroWindingNumberRule", testClipToPathNonzeroWindingNumberRule),
            ("testClipToPathEvenOddRule", testClipToPathEvenOddRule),
            ("testTextFont", testTextFont),
            ("testTextFontSize", testTextFontSize),
            ("testTextEncoding", testTextEncoding),
            ("testTextEncodingUnsupportedByCurrentFont", testTextEncodingUnsupportedByCurrentFont),
            ("testTextWidthForString", testTextWidthForString),
            ("testTextBoundingBox", testTextBoundingBox),
            ("testFontAscent", testFontAscent),
            ("testFontDescent", testFontDescent),
            ("testFontXHeight", testFontXHeight),
            ("testFontCapHeight", testFontCapHeight),
            ("testTextLeading", testTextLeading),
            ("testShowOnelineText", testShowOnelineText),
            ("testShowMultilineText", testShowMultilineText),
            ("testShowUnicodeText", testShowUnicodeText)
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
        page.draw { context in
            returnedInitialLineWidth = context.lineWidth
        }
        
        // Then
        XCTAssertEqual(expectedInitialLineWidth, returnedInitialLineWidth)
        
        // When
        var returnedLineWidth: Float = -1
        page.draw { context in
            context.lineWidth = 10
            returnedLineWidth = context.lineWidth
        }
        
        // Then
        XCTAssertEqual(expectedLineWidth, returnedLineWidth)
        
        // When
        var returnedFinalLineWidth: Float = -1
        page.draw { context in
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
        page.draw { context in
            returnedInitialDashStyle = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedInitialDashStyle, returnedInitialDashStyle)
        
        // When
        var returnedDashStyle1: DashStyle?
        page.draw { context in
            context.dashStyle = DashStyle(pattern: [10, 5], phase: 3)!
            returnedDashStyle1 = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedDashStyle1, returnedDashStyle1)
        
        // When
        var returnedDashStyle2: DashStyle?
        page.draw { context in
            context.dashStyle = DashStyle(pattern: [], phase: 10)!
            returnedDashStyle2 = context.dashStyle
        }
        
        // Then
        XCTAssertEqual(expectedDashStyle2, returnedDashStyle2)
        
        // When
        var returnedFinalDashStyle: DashStyle?
        page.draw { context in
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
        page.draw { context in
            returnedInitialLineCap = context.lineCap
        }
        
        // Then
        XCTAssertEqual(expectedInitialLineCap, returnedInitialLineCap)
        
        // When
        var returnedLineCap: LineCap?
        page.draw { context in
            context.lineCap = .round
            returnedLineCap = context.lineCap
        }
        
        // Then
        XCTAssertEqual(expectedLineCap, returnedLineCap)
        
        // When
        var returnedFinalLineCap: LineCap?
        page.draw { context in
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
        page.draw { context in
            returnedInitialLineJoin = context.lineJoin
        }
        
        // Then
        XCTAssertEqual(expectedInitialLineJoin, returnedInitialLineJoin)
        
        // When
        var returnedLineJoin: LineJoin?
        page.draw { context in
            context.lineJoin = .round
            returnedLineJoin = context.lineJoin
        }
        
        // Then
        XCTAssertEqual(expectedLineJoin, returnedLineJoin)
        
        // When
        var returnedFinalLineJoin: LineJoin?
        page.draw { context in
            returnedFinalLineJoin = context.lineJoin
        }
        
        // Then
        XCTAssertEqual(expectedFinalLineJoin, returnedFinalLineJoin)
    }
    
    func testPathMiterLimit() {
        
        // Given
        let expectedInitialMiterLimit: Float = 10
        let expectedMiterLimit: Float = 5
        let expectedFinalMiterLimit = expectedInitialMiterLimit
        
        // When
        var returnedInitialMiterLimit: Float = -1
        page.draw { context in
            returnedInitialMiterLimit = context.miterLimit
        }
        
        // Then
        XCTAssertEqual(expectedInitialMiterLimit, returnedInitialMiterLimit)
        
        // When
        var returnedMiterLimit: Float = -1
        page.draw { context in
            context.miterLimit = 5
            returnedMiterLimit = context.miterLimit
        }
        
        // Then
        XCTAssertEqual(expectedMiterLimit, returnedMiterLimit)
        
        // When
        var returnedFinalMiterLimit: Float = -1
        page.draw { context in
            returnedFinalMiterLimit = context.miterLimit
        }
        
        // Then
        XCTAssertEqual(expectedFinalMiterLimit, returnedFinalMiterLimit)
    }
    
    // MARK: - Color
    
    func testStrokeColorRGB() {
        
        // Given
        let expectedStrokeColor = Color(red: 0.1, green: 0.3, blue: 0.5)!
        let expectedColorSpace = PDFColorSpace.deviceRGB
        
        // When
        var returnedStrokeColor = Color(red: 0, green: 0, blue: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        page.draw { context in
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
        page.draw { context in
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
        page.draw { context in
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
        page.draw { context in
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
        page.draw { context in
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
        page.draw { context in
            context.fillColor = expectedFillColor
            returnedFillColor = context.fillColor
            returnedColorSpace = context.fillingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedFillColor, returnedFillColor)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    // MARK: - Path construction
    
    func testConstructPath() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        page.draw { context in
            
            let path = Path()
                .moving(toX: 100, y: 100)
                .appendingLine(toX: 400, y: 100)
                .moving(toX: 500, y: 200)
                .appendingArc(x: 400, y: 200, radius: 100, beginningAngle: 90, endAngle: 180)
                .moving(toX: 500, y: 200)
                .appendingCircle(x: 200, y: 200, radius: 50)
                .moving(toX: 500, y: 200)
                .appendingRectangle(x: 300, y: 200, width: 50, height: 100)
                .moving(toX: 500, y: 200)
                .appendingEllipse(x: 200, y: 200, horizontalRadius: 50, verticalRadius: 25)
                .appendingEllipse(inscribedIn: Rectangle(x: 300, y: 200, width: 50, height: 100))
                .moving(toX: 500, y: 200)
                .appendingCurve(controlPoint1: Point(x: 400, y: 200),
                                controlPoint2: Point(x: 400, y: 300),
                                endPoint: Point(x: 500, y: 300))
                .appendingCurve(controlPoint2: Point(x: 400, y: 400), endPoint: Point(x: 500, y: 400))
                .appendingCurve(controlPoint1: Point(x: 400, y: 400), endPoint: Point(x: 500, y: 500))
                .closingSubpath()
                .appendingCircle(x: 200, y: 200, radius: 75)
                .appendingRectangle(x: 325, y: 150, width: 50, height: 100)
                .appendingEllipse(x: 200, y: 200, horizontalRadius: 40, verticalRadius: 20)
            
            context.stroke(path)
        }
        
        // Test that creating circles, ellipses and rectangles starts a new subpath in `currentPosition`
        page.draw { context in
            let pathWithCircle = Path()
                .appendingCircle(x: 100, y: 400, radius: 30)
                .appendingLine(toX: 150, y: 400)
                .appendingLine(toX: 150, y: 450)
                .closingSubpath()
            
            let pathWithEllipse = Path()
                .appendingEllipse(x: 200, y: 400, horizontalRadius: 30, verticalRadius: 20)
                .appendingLine(toX: 250, y: 400)
                .appendingLine(toX: 250, y: 450)
                .closingSubpath()
            
            let pathWithRectangle = Path()
                .appendingRectangle(x: 270, y: 380, width: 60, height: 40)
                .appendingLine(toX: 350, y: 400)
                .appendingLine(toX: 350, y: 450)
                .closingSubpath()
            
            context.stroke(pathWithCircle)
            context.stroke(pathWithEllipse)
            context.stroke(pathWithRectangle)
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    // MARK: - Path paiting
    
    private func constructExampleCurve(startingWith point: Point) -> Path {
        
        let path = Path()
            .moving(to: point)
            .appendingLine(to: point + Vector(x: 37.5, y: -25))
            .appendingCurve(controlPoint1: point + Vector(x: 75, y: 0),
                            controlPoint2: point + Vector(x: 75, y: 137.5),
                            endPoint: point + Vector(x: 50, y: 125))
            .appendingCurve(controlPoint1: point + Vector(x: 25, y: 112.5),
                            controlPoint2: point + Vector(x: 12.5, y: 12.5),
                            endPoint: point + Vector(x: 62.5, y: 12.5))
            .appendingCurve(controlPoint1: point + Vector(x: 87.5, y: 12.5),
                            controlPoint2: point + Vector(x: 100, y: 25),
                            endPoint: point + Vector(x: 100, y: 0))
            .appendingCurve(controlPoint1: point + Vector(x: 100, y: -25),
                            controlPoint2: point + Vector(x: 50, y: -25),
                            endPoint: point + Vector(x: 25, y: 0))
            .appendingCurve(controlPoint1: point + Vector(x: 0, y: 25),
                            controlPoint2: point + Vector(x: -25, y: 75),
                            endPoint: point + Vector(x: 37.5, y: 87.5))
            .appendingCurve(controlPoint1: point + Vector(x: 100, y: 100),
                            controlPoint2: point + Vector(x: 100, y: -12.5),
                            endPoint: point + Vector(x: 25, y: -50))
            .closingSubpath()
        
        return path
    }
    
    func testPaintPath() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        
        // Draw some simple paths
        page.draw { context in
            
            let path1 = Path()
                .moving(toX: 100, y: 100)
                .appendingLine(toX: 500, y: 100)
            
            context.lineWidth = 3
            context.strokeColor = .red
            
            context.stroke(path1)
            
            let path2 = Path()
                .moving(toX: 100, y: 150)
                .appendingLine(toX: 500, y: 150)
                .appendingLine(toX: 500, y: 200)
                .appendingLine(toX: 100, y: 200)
            
            context.lineWidth = 5
            context.fillColor = .blue
            context.fill(path2, stroke: true)
        }
        
        // Filling using even-odd rule with stroking
        
        page.draw { context in
            XCTAssertEqual(context.lineWidth, 1)
            XCTAssertEqual(context.strokeColor, .black)
            XCTAssertEqual(context.fillColor, .black)
            
            let curve = constructExampleCurve(startingWith: Point(x: 100, y: 300))
            
            context.fillColor = .green
            context.fill(curve, evenOddRule: true, stroke: true)
        }
        
        // Filling using nonzero winding number rule with stroking
        
        page.draw { context in
            
            let curve = constructExampleCurve(startingWith: Point(x: 225, y: 300))
            
            context.fillColor = .green
            context.fill(curve, evenOddRule: false, stroke: true)
        }
        
        // Filling using even-odd number rule without stroking
        
        page.draw { context in
            
            let curve = constructExampleCurve(startingWith: Point(x: 100, y: 500))
            
            context.fillColor = .green
            context.fill(curve, evenOddRule: true, stroke: false)
        }
        
        // Filling using nonzero winding number rule without stroking
        
        page.draw { context in
            
            let curve = constructExampleCurve(startingWith: Point(x: 225, y: 500))
            
            context.fillColor = .green
            context.fill(curve, evenOddRule: false, stroke: false)
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testClipToPathNonzeroWindingNumberRule() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        
        let path = Path()
            .moving(toX: 100, y: 100)
            .appendingLine(toX: 200, y: 400)
            .appendingLine(toX: 300, y: 100)
            .appendingLine(toX: 50, y: 300)
            .appendingLine(toX: 350, y: 300)
            .closingSubpath()
        
        let rectangle = Path().appendingRectangle(x: 75, y: 150, width: 250, height: 200)
        
        page.draw { context in
            
            context.stroke(path)
            context.clip(to: path, evenOddRule: false) {
                context.fill(rectangle)
            }
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testClipToPathEvenOddRule() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        
        let path = Path()
            .moving(toX: 100, y: 100)
            .appendingLine(toX: 200, y: 400)
            .appendingLine(toX: 300, y: 100)
            .appendingLine(toX: 50, y: 300)
            .appendingLine(toX: 350, y: 300)
            .closingSubpath()
        
        let rectangle = Path().appendingRectangle(x: 75, y: 150, width: 250, height: 200)
        
        page.draw { context in
            
            context.stroke(path)
            context.clip(to: path, evenOddRule: true) {
                context.fill(rectangle)
            }
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    // MARK: - Text State
    
    func testTextFont() {
        
        // Given
        let expectedInitialFont = Font.helvetica
        let expectedFont = Font.courierBold
        let expectedFinalFont = expectedInitialFont
        
        // When
        var returnedInitialFont: Font?
        page.draw { context in
            returnedInitialFont = context.font
        }
        
        // Then
        XCTAssertEqual(expectedInitialFont, returnedInitialFont)
        
        // When
        var returnedFont: Font?
        page.draw { context in
            
            context.font = .courierBold
            returnedFont = context.font
        }
        
        // Then
        XCTAssertEqual(expectedFont, returnedFont)
        
        // When
        var returnedFinalFont: Font?
        page.draw { context in
            returnedFinalFont = context.font
        }
        
        // Then
        XCTAssertEqual(expectedFinalFont, returnedFinalFont)
    }
    
    func testTextFontSize() {
        
        // Given
        let expectedInitialFontSize: Float = 11
        let expectedFontSize: Float = 64
        let expectedFinalFontSize = expectedInitialFontSize
        
        // When
        var returnedInitialFontSize: Float?
        page.draw { context in
            returnedInitialFontSize = context.fontSize
        }
        
        // Then
        XCTAssertEqual(expectedInitialFontSize, returnedInitialFontSize)
        
        // When
        var returnedFontSize: Float?
        page.draw { context in
            
            context.fontSize = 64
            returnedFontSize = context.fontSize
        }
        
        // Then
        XCTAssertEqual(expectedFontSize, returnedFontSize)
        
        // When
        var returnedFinalFontSize: Float?
        page.draw { context in
            returnedFinalFontSize = context.fontSize
        }
        
        // Then
        XCTAssertEqual(expectedFinalFontSize, returnedFinalFontSize)
    }
    
    func testTextEncoding() {
        
        // Given
        let expectedInitialEncoding = Encoding.standard
        let expectedEncoding = Encoding.cp1251
        let expectedFinalEncoding = expectedInitialEncoding
        
        // When
        var returnedInitialEncoding: Encoding?
        page.draw { context in
            returnedInitialEncoding = context.encoding
        }
        
        // Then
        XCTAssertEqual(expectedInitialEncoding, returnedInitialEncoding)
        
        // When
        var returnedEncoding: Encoding?
        page.draw { context in
            
            context.encoding = .cp1251
            returnedEncoding = context.encoding
        }
        
        // Then
        XCTAssertEqual(expectedEncoding, returnedEncoding)
        
        // When
        var returnedFinalEncoding: Encoding?
        page.draw { context in
            returnedFinalEncoding = context.encoding
        }
        
        // Then
        XCTAssertEqual(expectedFinalEncoding, returnedFinalEncoding)
    }
    
    func testTextEncodingUnsupportedByCurrentFont() {
        
        // Given
        let expectedEncoding = Encoding.standard
        
        // When
        var returnedEncoding: Encoding?
        page.draw { context in
            context.font = .helvetica
            context.encoding = .utf8
            returnedEncoding = context.encoding
        }
        
        // Then
        XCTAssertEqual(expectedEncoding, returnedEncoding)
    }
    
    func testTextWidthForString() {
        
        // Given
        let expectedWidth: Float = 62.953
        let expectedWidthForMultilineText: Float = 70.3119965
        let text = "Hello, World!"
        let multilineText = "I don't actually\nlike lemons."
        
        // When
        var returnedWidth: Float?
        page.draw { context in
            returnedWidth = context.textWidth(for: text)
        }
        
        // Then
        XCTAssertEqual(expectedWidth, returnedWidth)
        
        // When
        var returnedWidthForMultilineText: Float?
        page.draw { context in
            returnedWidthForMultilineText = context.textWidth(for: multilineText)
        }
        
        // Then
        XCTAssertEqual(expectedWidthForMultilineText, returnedWidthForMultilineText)
    }
    
    func testTextBoundingBox() {
        
        // Given
        let expectedBBox = Rectangle(x: 100,
                                     y: 97.7229996,
                                     width: 62.9529991,
                                     height: 10.1749992)
        let expectedBBoxForMultilineText = Rectangle(x: 100.0,
                                                     y: 64.7229996,
                                                     width: 58.0690002,
                                                     height: 43.1749992)
        let text = "Hello, World!"
        let multilineText = "I\ndon't\nactually\nlike lemons."
        let textPosition = Point(x: 100, y: 100)
        
        // When
        var returnedBBox: Rectangle?
        page.draw { context in
            returnedBBox = context.boundingBox(for: text, atPosition: textPosition)
        }
        
        // Then
        XCTAssertEqual(expectedBBox, returnedBBox)
        
        // When
        var returnedBBoxForMultilineText: Rectangle?
        page.draw { context in
            returnedBBoxForMultilineText = context.boundingBox(for: multilineText, atPosition: textPosition)
        }
        
        // Then
        XCTAssertEqual(expectedBBoxForMultilineText, returnedBBoxForMultilineText)
    }
    
    func testFontAscent() {
        
        // Given
        let expectedAscentForHelvetica: Float = 7.89799976
        let expectedAscentForTimes: Float = 20.4899998
        
        // When
        var returnedAscentForHelvetica: Float?
        page.draw { context in
            returnedAscentForHelvetica = context.fontAscent
        }
        
        // Then
        XCTAssertEqual(expectedAscentForHelvetica, returnedAscentForHelvetica)
        
        // When
        var returnedAscentForTimes: Float?
        page.draw { context in
            context.font = .timesRoman
            context.fontSize = 30
            returnedAscentForTimes = context.fontAscent
        }
        
        // Then
        XCTAssertEqual(expectedAscentForTimes, returnedAscentForTimes)
    }
    
    func testFontDescent() {
        
        // Given
        let expectedDescentForHelvetica: Float = -2.27699995
        let expectedDescentForTimes: Float = -6.51000023
        
        // When
        var returnedDescentForHelvetica: Float?
        page.draw { context in
            returnedDescentForHelvetica = context.fontDescent
        }
        
        // Then
        XCTAssertEqual(expectedDescentForHelvetica, returnedDescentForHelvetica)
        
        // When
        var returnedDescentForTimes: Float?
        page.draw { context in
            context.font = .timesRoman
            context.fontSize = 30
            returnedDescentForTimes = context.fontDescent
        }
        
        // Then
        XCTAssertEqual(expectedDescentForTimes, returnedDescentForTimes)
    }
    
    func testFontXHeight() {
        
        // Given
        let expectedXHeightForHelvetica: Float = 5.75299978
        let expectedXHeightForTimes: Float = 13.5
        
        // When
        var returnedXHeightForHelvetica: Float?
        page.draw { context in
            returnedXHeightForHelvetica = context.fontXHeight
        }
        
        // Then
        XCTAssertEqual(expectedXHeightForHelvetica, returnedXHeightForHelvetica)
        
        // When
        var returnedXHeightForTimes: Float?
        page.draw { context in
            context.font = .timesRoman
            context.fontSize = 30
            returnedXHeightForTimes = context.fontXHeight
        }
        
        // Then
        XCTAssertEqual(expectedXHeightForTimes, returnedXHeightForTimes)
    }
    
    func testFontCapHeight() {
        
        // Given
        let expectedCapHeightForHelvetica: Float = 7.89799976
        let expectedCapHeightForTimes: Float = 19.8600006
        
        // When
        var returnedCapHeightForHelvetica: Float?
        page.draw { context in
            returnedCapHeightForHelvetica = context.fontCapHeight
        }
        
        // Then
        XCTAssertEqual(expectedCapHeightForHelvetica, returnedCapHeightForHelvetica)
        
        // When
        var returnedCapHeightForTimes: Float?
        page.draw { context in
            context.font = .timesRoman
            context.fontSize = 30
            returnedCapHeightForTimes = context.fontCapHeight
        }
        
        // Then
        XCTAssertEqual(expectedCapHeightForTimes, returnedCapHeightForTimes)
    }
    
    func testTextLeading() {
        
        // Given
        let expectedInitialTextLeading: Float = 11
        let expectedTextLeading: Float = 24
        let expectedFinalTextLeading = expectedInitialTextLeading
        
        // When
        var returnedInitialTextLeading: Float?
        page.draw { context in
            returnedInitialTextLeading = context.textLeading
        }
        
        // Then
        XCTAssertEqual(expectedInitialTextLeading, returnedInitialTextLeading)
        
        // When
        var returnedTextLeading: Float?
        page.draw { context in
            context.textLeading = 24
            returnedTextLeading = context.textLeading
        }
        
        // Then
        XCTAssertEqual(expectedTextLeading, returnedTextLeading)
        
        // When
        var returnedFinalTextLeading: Float?
        page.draw { context in
            returnedFinalTextLeading = context.textLeading
        }
        
        // Then
        XCTAssertEqual(expectedFinalTextLeading, returnedFinalTextLeading)
    }
    
    // MARK: - Text Showing
    
    func testShowOnelineText() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        page.draw { context in
            context.show(text: "Hello World!", atX: 100, y: 100)
            context.show(text: "", atX: 100, y: 200)
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testShowMultilineText() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        page.draw { context in
            context.show(text: "Roses are red,\nViolets are blue,\nSugar is sweet,\nAnd so are you.",
                         atX: 100, y: 200)
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testShowUnicodeText() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let fontData = getTestingResource(fromFile: "Andale Mono", ofType: "ttf")!
        let loadedFont = try! document.loadTrueTypeFont(from: fontData, embeddingGlyphData: true)
        
        // When
        page.draw { context in
            
            context.font = loadedFont
            context.encoding = .utf8
            
            context.show(text: "Math poetry!", atX: 100, y: 220)
            
            context.show(text: "Гомоморфный образ группы,\n" +
                "(Будь во имя коммунизма)\n" +
                "Изоморфен фактор-группе\n" +
                "По ядру гомоморфизма.",
                         atX: 100, y: 200)
            
            // Test that setting a multibyte encoding twice doesn't cause an error in LibHaru
            context.encoding = .utf8
        }
        
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
}
