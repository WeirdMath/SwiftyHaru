//
//  DrawingContextTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 05.10.16.
//
//

import XCTest
import SwiftyHaru

final class DrawingContextTests: TestCase {
    
    static let allTests = [
        // Graphics state
        ("testPathLineWidth", testPathLineWidth),
        ("testPathDashStyle", testPathDashStyle),
        ("testPathLineCap", testPathLineCap),
        ("testPathLineJoin", testPathLineJoin),
        ("testPathMiterLimit", testPathMiterLimit),
        ("testSaveRestoreGState", testSaveRestoreGState),
        ("testGetGraphicsStateDepth", testGetGraphicsStateDepth),
        ("testRotateContext", testRotateContext),
        ("testScaleContext", testScaleContext),
        ("testTranslateContext", testTranslateContext),
        // Color
        ("testStrokeColorRGB", testStrokeColorRGB),
        ("testStrokeColorCMYK", testStrokeColorCMYK),
        ("testStrokeColorGray", testStrokeColorGray),
        ("testFillColorRGB", testFillColorRGB),
        ("testFillColorCMYK", testFillColorCMYK),
        ("testFillColorGray", testFillColorGray),
        // Path construction
        ("testConstructPath", testConstructPath),
        // Path painting
        ("testPaintPath", testPaintPath),
        ("testClipToPathNonzeroWindingNumberRule", testClipToPathNonzeroWindingNumberRule),
        ("testClipToPathEvenOddRule", testClipToPathEvenOddRule),
        // Text state
        ("testTextFont", testTextFont),
        ("testTextFontSize", testTextFontSize),
        ("testTextEncoding", testTextEncoding),
        ("testTextEncodingUnsupportedByCurrentFont", testTextEncodingUnsupportedByCurrentFont),
        ("testTextWidthForString", testTextWidthForString),
        ("testMeasureText", testMeasureText),
        ("testTextBoundingBox", testTextBoundingBox),
        ("testFontAscent", testFontAscent),
        ("testFontDescent", testFontDescent),
        ("testFontXHeight", testFontXHeight),
        ("testFontCapHeight", testFontCapHeight),
        ("testTextLeading", testTextLeading),
        ("testTextRenderingMode", testTextRenderingMode),
        ("testCharacterSpacing", testCharacterSpacing),
        ("testWordSpacing", testWordSpacing),
        // Text showing
        ("testShowOnelineText", testShowOnelineText),
        ("testShowMultilineText", testShowMultilineText),
        ("testShowUnicodeText", testShowUnicodeText),
        ("testShowTextInRect", testShowTextInRect),
        ("testShowWithTextMatrix", testShowWithTextMatrix)
    ]
    
    // MARK: - Helpers
    
    private func drawPoint(_ p: Point, in context: DrawingContext) {
        let size = Size(width: 2, height: 2).applying(context.currentTransform.inverted())
        let path = Path()
            .appendingEllipse(center: p, horizontalRadius: size.width, verticalRadius: size.height)
        
        context.withNewGState {
            context.fillColor = .red
            context.fill(path)
        }
    }
    
    private func drawSampleGrid(in context: DrawingContext) throws {
        
        let grid = Grid(width: context.page.width / 2, height: context.page.height / 2)
        let gridCenter = Point(x: context.page.width / 2, y: context.page.height / 2)
        let gridOrigin = gridCenter - Point(x: context.page.width / 4, y: context.page.height / 4)
        
        try grid.draw(in: context, position: .zero + gridOrigin)
        drawPoint(gridCenter, in: context)
    }

    private func drawStripePattern(in context: DrawingContext, rect: Rectangle) {
        let savedLineWidth = context.lineWidth
        let savedStrokeColor = context.strokeColor
        defer {
            context.lineWidth = savedLineWidth
            context.strokeColor = savedStrokeColor
        }

        context.lineWidth = 1
        context.strokeColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)

        for dy in stride(from: 0 as Float, to: rect.maxY, by: 3) {
            context.stroke(
                Path()
                    .moving(toX: rect.x, y: rect.y + dy)
                    .appendingLine(toX: rect.maxX, y: rect.y + dy)
            )
        }
    }
    
    // MARK: - Graphics state
    
    func testPathLineWidth() {
        
        // Given
        let expectedInitialLineWidth: Float = 1
        let expectedLineWidth: Float = 10

        // When
        var returnedInitialLineWidth: Float = -1
        var returnedLineWidth: Float        = -1

        document.addPage { context in
            returnedInitialLineWidth = context.lineWidth
            context.lineWidth = 10
            returnedLineWidth = context.lineWidth
        }

        // Then
        XCTAssertEqual(expectedInitialLineWidth, returnedInitialLineWidth)
        XCTAssertEqual(expectedLineWidth, returnedLineWidth)
    }
    
    func testPathDashStyle() {
        
        // Given
        let expectedInitialDashStyle = DashStyle.straightLine
        let expectedDashStyle1 = DashStyle(pattern: [10, 5], phase: 3)!
        let expectedDashStyle2 = DashStyle(pattern: [], phase: 0)!

        // When
        var returnedInitialDashStyle: DashStyle?
        var returnedDashStyle1: DashStyle?
        var returnedDashStyle2: DashStyle?

        document.addPage { context in
            returnedInitialDashStyle = context.dashStyle
            context.dashStyle = DashStyle(pattern: [10, 5], phase: 3)!
            returnedDashStyle1 = context.dashStyle
            context.dashStyle = DashStyle(pattern: [], phase: 10)!
            returnedDashStyle2 = context.dashStyle
        }

        // Then
        XCTAssertEqual(expectedInitialDashStyle, returnedInitialDashStyle)
        XCTAssertEqual(expectedDashStyle1, returnedDashStyle1)
        XCTAssertEqual(expectedDashStyle2, returnedDashStyle2)
    }
    
    func testPathLineCap() {
        
        // Given
        let expectedInitialLineCap = LineCap.butt
        let expectedLineCap = LineCap.round
        
        // When
        var returnedInitialLineCap: LineCap?
        var returnedLineCap: LineCap?

        document.addPage { context in
            returnedInitialLineCap = context.lineCap
            context.lineCap = .round
            returnedLineCap = context.lineCap
        }

        // Then
        XCTAssertEqual(expectedInitialLineCap, returnedInitialLineCap)
        XCTAssertEqual(expectedLineCap, returnedLineCap)
    }
    
    func testPathLineJoin() {
        
        // Given
        let expectedInitialLineJoin = LineJoin.miter
        let expectedLineJoin = LineJoin.round

        // When
        var returnedInitialLineJoin: LineJoin?
        var returnedLineJoin: LineJoin?

        document.addPage { context in
            returnedInitialLineJoin = context.lineJoin
            context.lineJoin = .round
            returnedLineJoin = context.lineJoin
        }

        // Then
        XCTAssertEqual(expectedInitialLineJoin, returnedInitialLineJoin)
        XCTAssertEqual(expectedLineJoin, returnedLineJoin)
    }
    
    func testPathMiterLimit() {
        
        // Given
        let expectedInitialMiterLimit: Float = 10
        let expectedMiterLimit: Float = 5

        // When
        var returnedInitialMiterLimit: Float = -1
        var returnedMiterLimit: Float = -1
        document.addPage { context in
            returnedInitialMiterLimit = context.miterLimit
            context.miterLimit = 5
            returnedMiterLimit = context.miterLimit
        }

        // Then
        XCTAssertEqual(expectedInitialMiterLimit, returnedInitialMiterLimit)
        XCTAssertEqual(expectedMiterLimit, returnedMiterLimit)
    }

    func testSaveRestoreGState() {

        // Given
        let expectedOuterColor = Color.red

        // When
        var returnedOuterColor: Color?
        document.addPage { context in

            context.fillColor = expectedOuterColor
            
            context.withNewGState {
                context.fillColor = .blue
            }

            returnedOuterColor = context.fillColor

        }
        
        // Then
        XCTAssertEqual(expectedOuterColor, returnedOuterColor)
    }
    
    func testGetGraphicsStateDepth() {

        // When
        var depthOuterBefore: Int?
        var depthNewGStateBefore: Int?
        var depthClip: Int?
        var depthNewGStateAfter: Int?
        var depthOuterAfter: Int?

        document.addPage { context in

            depthOuterBefore = context.graphicsStateDepth

            context.withNewGState {

                depthNewGStateBefore = context.graphicsStateDepth

                context.clip(to: Path()) {

                    depthClip = context.graphicsStateDepth

                }
                
                depthNewGStateAfter = context.graphicsStateDepth
            }
            
            depthOuterAfter = context.graphicsStateDepth
        }

        // Then
        XCTAssertEqual(depthOuterBefore, 1)
        XCTAssertEqual(depthNewGStateBefore, 2)
        XCTAssertEqual(depthClip, 3)
        XCTAssertEqual(depthNewGStateAfter, 2)
        XCTAssertEqual(depthOuterAfter, 1)
    }
    
    // MARK: Transforms

    typealias AffineTransform = SwiftyHaru.AffineTransform
    
    func testRotateContext() throws {

        // Given
        let angle: Float = .pi / 180 * 10
        let expectedTransform = AffineTransform(rotationAngle: angle)
        
        // When
        var returnedTransform: AffineTransform?
        try document.addPage { context in
            
            try self.drawSampleGrid(in: context)
            
            context.rotate(byAngle: angle)
            
            try self.drawSampleGrid(in: context)
            
            returnedTransform = context.currentTransform
        }

        // Then
        XCTAssertEqual(expectedTransform, returnedTransform)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testScaleContext() throws {

        // Given
        let sx: Float = 0.7
        let sy: Float = 1.3
        let expectedTransform = AffineTransform(scaleX: sx, y: sy)
        
        // When
        var returnedTransform: AffineTransform?
        try document.addPage { context in
            
            try self.drawSampleGrid(in: context)
            
            context.scale(byX: sx, y: sy)
            
            try self.drawSampleGrid(in: context)
            
            returnedTransform = context.currentTransform
        }

        // Then
        XCTAssertEqual(expectedTransform, returnedTransform)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testTranslateContext() throws {

        // Given
        let tx: Float = -PDFPage.defaultWidth / 3
        let ty: Float = PDFPage.defaultHeight / 5
        let expectedTransform = AffineTransform(translationX: tx, y: ty)
        
        // When
        var returnedTransform: AffineTransform?
        try document.addPage { context in
            
            try self.drawSampleGrid(in: context)
            
            context.translate(byX: tx, y: ty)
            
            try self.drawSampleGrid(in: context)
            
            returnedTransform = context.currentTransform
        }
        
        // Then
        XCTAssertEqual(expectedTransform, returnedTransform)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testConcatContext() throws {

        // Given
        let expectedTransform = AffineTransform(translationX: 100, y: 200)
            .scaled(byX: 1.5, y: 0.5)
            .rotated(byAngle: .pi / 6)
        
        // When
        var returnedTransform: AffineTransform?
        try document.addPage { context in
            
            try self.drawSampleGrid(in: context)
            
            context.concatenate(expectedTransform)
            
            try self.drawSampleGrid(in: context)
            
            returnedTransform = context.currentTransform
        }
                
        // Then
        XCTAssertEqual(expectedTransform, returnedTransform)
        assertPDFSnapshot()
    }
    
    // MARK: - Color
    
    func testStrokeColorRGB() {
        
        // Given
        let expectedInitialStrokeColor = Color.black
        let expectedStrokeColor = Color(red: 0.1, green: 0.3, blue: 0.5)!
        let expectedInitialColorSpace = PDFColorSpace.deviceGray
        let expectedColorSpace = PDFColorSpace.deviceRGB
        
        // When
        var returnedInitialStrokeColor: Color?
        var returnedStrokeColor: Color?
        var returnedInitialColorSpace: PDFColorSpace?
        var returnedColorSpace: PDFColorSpace?
        document.addPage { context in
            returnedInitialColorSpace = context.strokingColorSpace
            returnedInitialStrokeColor = context.strokeColor
            context.strokeColor = expectedStrokeColor
            returnedStrokeColor = context.strokeColor
            returnedColorSpace = context.strokingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedInitialStrokeColor, returnedInitialStrokeColor)
        XCTAssertEqual(expectedStrokeColor, returnedStrokeColor)
        XCTAssertEqual(expectedInitialColorSpace, returnedInitialColorSpace)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testStrokeColorCMYK() {
        
        // Given
        let expectedStrokeColor = Color(cyan: 0.1, magenta: 0.3, yellow: 0.5, black: 0.7)!
        let expectedColorSpace = PDFColorSpace.deviceCMYK
        
        // When
        var returnedStrokeColor = Color(cyan: 0, magenta: 0, yellow: 0, black: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        document.addPage { context in
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
        document.addPage { context in
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
        let expectedInitialFillColor = Color.black
        let expectedFillColor = Color(red: 0.1, green: 0.3, blue: 0.5)!
        let expectedInitialColorSpace = PDFColorSpace.deviceGray
        let expectedColorSpace = PDFColorSpace.deviceRGB
        
        // When
        var returnedInitialFillColor: Color?
        var returnedFillColor: Color?
        var returnedInitialColorSpace: PDFColorSpace?
        var returnedColorSpace: PDFColorSpace?
        document.addPage { context in
            returnedInitialColorSpace = context.fillingColorSpace
            returnedInitialFillColor = context.fillColor
            context.fillColor = expectedFillColor
            returnedFillColor = context.fillColor
            returnedColorSpace = context.fillingColorSpace
        }
        
        // Then
        XCTAssertEqual(expectedInitialFillColor, returnedInitialFillColor)
        XCTAssertEqual(expectedFillColor, returnedFillColor)
        XCTAssertEqual(expectedInitialColorSpace, returnedInitialColorSpace)
        XCTAssertEqual(expectedColorSpace, returnedColorSpace)
    }
    
    func testFillColorCMYK() {
        
        // Given
        let expectedFillColor = Color(cyan: 0.1, magenta: 0.3, yellow: 0.5, black: 0.7)!
        let expectedColorSpace = PDFColorSpace.deviceCMYK
        
        // When
        var returnedFillColor = Color(cyan: 0, magenta: 0, yellow: 0, black: 0)!
        var returnedColorSpace = PDFColorSpace.undefined
        document.addPage { context in
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
        document.addPage { context in
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

        // When
        document.addPage { context in
            
            let path = Path()
                .moving(toX: 100, y: 100)
                .appendingLine(toX: 400, y: 100)
                .moving(toX: 500, y: 200)
                .appendingArc(x: 400, y: 200, radius: 100, beginningAngle: 90, endAngle: 180)
                .appendingLine(toX: 500, y: 200)
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

            // Test that creating circles, ellipses and rectangles starts a new subpath in `currentPosition`
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

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    // MARK: - Path paiting
    
    private func constructExampleCurve(startingWith point: Point) -> Path {
        
        let path = Path()
            .moving(to: point)
            .appendingLine(to: point + Vector(dx: 37.5, dy: -25))
            .appendingCurve(controlPoint1: point + Vector(dx: 75, dy: 0),
                            controlPoint2: point + Vector(dx: 75, dy: 137.5),
                            endPoint: point + Vector(dx: 50, dy: 125))
            .appendingCurve(controlPoint1: point + Vector(dx: 25, dy: 112.5),
                            controlPoint2: point + Vector(dx: 12.5, dy: 12.5),
                            endPoint: point + Vector(dx: 62.5, dy: 12.5))
            .appendingCurve(controlPoint1: point + Vector(dx: 87.5, dy: 12.5),
                            controlPoint2: point + Vector(dx: 100, dy: 25),
                            endPoint: point + Vector(dx: 100, dy: 0))
            .appendingCurve(controlPoint1: point + Vector(dx: 100, dy: -25),
                            controlPoint2: point + Vector(dx: 50, dy: -25),
                            endPoint: point + Vector(dx: 25, dy: 0))
            .appendingCurve(controlPoint1: point + Vector(dx: 0, dy: 25),
                            controlPoint2: point + Vector(dx: -25, dy: 75),
                            endPoint: point + Vector(dx: 37.5, dy: 87.5))
            .appendingCurve(controlPoint1: point + Vector(dx: 100, dy: 100),
                            controlPoint2: point + Vector(dx: 100, dy: -12.5),
                            endPoint: point + Vector(dx: 25, dy: -50))
            .closingSubpath()
        
        return path
    }
    
    func testPaintPath() {

        // When
        
        // Draw some simple paths
        document.addPage { context in
            
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

            // Filling using even-odd rule with stroking
            let curve1 = self.constructExampleCurve(startingWith: Point(x: 100, y: 300))

            context.lineWidth = 1
            context.fillColor = .green
            context.strokeColor = .black
            context.fill(curve1, rule: .evenOdd, stroke: true)

            // Filling using nonzero winding number rule with stroking
            let curve2 = self.constructExampleCurve(startingWith: Point(x: 225, y: 300))
            
            context.fillColor = .green
            context.fill(curve2, rule: .winding, stroke: true)

            // Filling using even-odd number rule without stroking

            let curve3 = self.constructExampleCurve(startingWith: Point(x: 100, y: 500))
            
            context.fillColor = .green
            context.fill(curve3, rule: .evenOdd, stroke: false)

            // Filling using nonzero winding number rule without stroking
            let curve4 = self.constructExampleCurve(startingWith: Point(x: 225, y: 500))
            
            context.fillColor = .green
            context.fill(curve4, rule: .winding, stroke: false)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testClipToPathNonzeroWindingNumberRule() {
        
        // When
        
        let path = Path()
            .moving(toX: 100, y: 100)
            .appendingLine(toX: 200, y: 400)
            .appendingLine(toX: 300, y: 100)
            .appendingLine(toX: 50, y: 300)
            .appendingLine(toX: 350, y: 300)
            .closingSubpath()
        
        let rectangle = Path().appendingRectangle(x: 75, y: 150, width: 250, height: 200)
        
        document.addPage { context in
            
            context.stroke(path)
            
            context.clip(to: path, rule: .winding) {
                context.fill(rectangle)
            }
        }
        
        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testClipToPathEvenOddRule() {

        // When
        let path = Path()
            .moving(toX: 100, y: 100)
            .appendingLine(toX: 200, y: 400)
            .appendingLine(toX: 300, y: 100)
            .appendingLine(toX: 50, y: 300)
            .appendingLine(toX: 350, y: 300)
            .closingSubpath()
        
        let rectangle = Path().appendingRectangle(x: 75, y: 150, width: 250, height: 200)
        
        document.addPage { context in
            
            context.stroke(path)
            
            context.clip(to: path, rule: .evenOdd) {
                context.fill(rectangle)
            }
        }
                
        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    // MARK: - Text State
    
    func testTextFont() throws {
        
        // Given
        let expectedInitialFont = Font.helvetica

        // When
        var returnedInitialFont: Font?

        try document.addPage { context in
            returnedInitialFont = context.font

            let ys = sequence(first: 100, next: { $0 + 1.2 * context.fontSize })
            for (font, y) in zip(Font.baseFonts, ys) {
                context.font = font
                try context.show(text: font.name, atX: 100, y: y)
            }
        }

        // Then
        XCTAssertEqual(expectedInitialFont, returnedInitialFont)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testTextFontSize() throws {
        
        // Given
        let expectedInitialFontSize: Float = 11

        // When
        var returnedInitialFontSize: Float?

        try document.addPage { context in
            returnedInitialFontSize = context.fontSize

            let fontSizes = stride(from: 1 as Float, to: 70, by: 5)
            let ys = sequence(first: 100, next: { $0 + 1.2 * context.fontSize })

            for (fontSize, y) in zip(fontSizes, ys) {
                context.fontSize = fontSize
                try context.show(text: "font size is \(Int(fontSize))", atX: 100, y: y)
            }
        }

        // Then
        XCTAssertEqual(expectedInitialFontSize, returnedInitialFontSize)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testTextEncoding() {
        
        // Given
        let expectedInitialEncoding = Encoding.standard
        let expectedEncoding = Encoding.cp1251

        // When
        var returnedInitialEncoding: Encoding?
        var returnedEncoding: Encoding?

        document.addPage { context in
            returnedInitialEncoding = context.encoding
            context.encoding = .cp1251
            returnedEncoding = context.encoding
        }

        // Then
        XCTAssertEqual(expectedInitialEncoding, returnedInitialEncoding)
        XCTAssertEqual(expectedEncoding, returnedEncoding)
    }
    
    func testTextEncodingUnsupportedByCurrentFont() {
        
        // Given
        let expectedEncoding = Encoding.standard
        
        // When
        var returnedEncoding: Encoding?
        document.addPage { context in
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
        var returnedWidthForMultilineText: Float?
        document.addPage { context in
            returnedWidth = context.textWidth(for: text)
            returnedWidthForMultilineText = context.textWidth(for: multilineText)
        }

        // Then
        XCTAssertEqual(expectedWidth, returnedWidth)
        XCTAssertEqual(expectedWidthForMultilineText, returnedWidthForMultilineText)
    }

    func testMeasureText() throws {

        // Given
        let expectedLengthNoWordwrap = 12
        let expectedWidthNoWordwrap: Float = 75.78999
        let expectedLengthWordwrap = 10
        let expectedWidthWordwrap: Float = 64.173996
        let text = "ABCDE FGH IJKL"

        // When
        var returnedLengthNoWordwrap: Int?
        var returnedWidthNoWordwrap: Float?
        var returnedLengthWordwrap: Int?
        var returnedWidthWordwrap: Float?

        try document.addPage { context in

            let noWordWrap = try context.measureText(text, width: 80, wordwrap: false)
            returnedLengthNoWordwrap = noWordWrap.utf8Length
            returnedWidthNoWordwrap  = noWordWrap.realWidth

            let withWordWrap = try context.measureText(text, width: 80, wordwrap: true)
            returnedLengthWordwrap = withWordWrap.utf8Length
            returnedWidthWordwrap  = withWordWrap.realWidth
        }

        // Then
        XCTAssertEqual(expectedLengthNoWordwrap, returnedLengthNoWordwrap)
        XCTAssertEqual(expectedWidthNoWordwrap, returnedWidthNoWordwrap)
        XCTAssertEqual(expectedLengthWordwrap, returnedLengthWordwrap)
        XCTAssertEqual(expectedWidthWordwrap, returnedWidthWordwrap)
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
        var returnedBBoxForMultilineText: Rectangle?

        document.addPage { context in
            context.textLeading = 11
            returnedBBox = context.boundingBox(for: text, atPosition: textPosition)
            returnedBBoxForMultilineText = context.boundingBox(for: multilineText, atPosition: textPosition)
        }

        // Then
        XCTAssertEqual(expectedBBox, returnedBBox)
        XCTAssertEqual(expectedBBoxForMultilineText, returnedBBoxForMultilineText)
    }
    
    func testFontAscent() {
        
        // Given
        let expectedAscentForHelvetica: Float = 7.89799976
        let expectedAscentForTimes: Float = 20.4899998
        
        // When
        var returnedAscentForHelvetica: Float?
        var returnedAscentForTimes: Float?

        document.addPage { context in
            returnedAscentForHelvetica = context.fontAscent
            context.font = .timesRoman
            context.fontSize = 30
            returnedAscentForTimes = context.fontAscent
        }

        // Then
        XCTAssertEqual(expectedAscentForHelvetica, returnedAscentForHelvetica)
        XCTAssertEqual(expectedAscentForTimes, returnedAscentForTimes)
    }
    
    func testFontDescent() {
        
        // Given
        let expectedDescentForHelvetica: Float = -2.27699995
        let expectedDescentForTimes: Float = -6.51000023
        
        // When
        var returnedDescentForHelvetica: Float?
        var returnedDescentForTimes: Float?

        document.addPage { context in
            returnedDescentForHelvetica = context.fontDescent
            context.font = .timesRoman
            context.fontSize = 30
            returnedDescentForTimes = context.fontDescent
        }

        // Then
        XCTAssertEqual(expectedDescentForHelvetica, returnedDescentForHelvetica)
        XCTAssertEqual(expectedDescentForTimes, returnedDescentForTimes)
    }
    
    func testFontXHeight() {
        
        // Given
        let expectedXHeightForHelvetica: Float = 5.75299978
        let expectedXHeightForTimes: Float = 13.5
        
        // When
        var returnedXHeightForHelvetica: Float?
        var returnedXHeightForTimes: Float?

        document.addPage { context in
            returnedXHeightForHelvetica = context.fontXHeight
            context.font = .timesRoman
            context.fontSize = 30
            returnedXHeightForTimes = context.fontXHeight
        }

        // Then
        XCTAssertEqual(expectedXHeightForHelvetica, returnedXHeightForHelvetica)
        XCTAssertEqual(expectedXHeightForTimes, returnedXHeightForTimes)
    }
    
    func testFontCapHeight() {
        
        // Given
        let expectedCapHeightForHelvetica: Float = 7.89799976
        let expectedCapHeightForTimes: Float = 19.8600006
        
        // When
        var returnedCapHeightForHelvetica: Float?
        var returnedCapHeightForTimes: Float?

        document.addPage { context in
            returnedCapHeightForHelvetica = context.fontCapHeight
            context.font = .timesRoman
            context.fontSize = 30
            returnedCapHeightForTimes = context.fontCapHeight
        }

        // Then
        XCTAssertEqual(expectedCapHeightForHelvetica, returnedCapHeightForHelvetica)
        XCTAssertEqual(expectedCapHeightForTimes, returnedCapHeightForTimes)
    }
    
    func testTextLeading() {
        
        // Given
        let expectedInitialTextLeading: Float = 0
        let expectedTextLeading: Float = 24

        // When
        var returnedInitialTextLeading: Float?
        var returnedTextLeading: Float?
        document.addPage { context in
            returnedInitialTextLeading = context.textLeading
            context.textLeading = 24
            returnedTextLeading = context.textLeading
        }

        // Then
        XCTAssertEqual(expectedInitialTextLeading, returnedInitialTextLeading)
        XCTAssertEqual(expectedTextLeading, returnedTextLeading)
    }

    func testTextRenderingMode() throws {

        // Given
        let expectedInitialMode = TextRenderingMode.fill

        // When
        var returnedInitialMode: TextRenderingMode?

        try document.addPage { context in

            returnedInitialMode = context.textRenderingMode

            context.fillColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            context.fontSize = 24

            let ys = sequence(first: 100, next: { $0 + 2 * context.fontSize })
            for (mode, y) in zip(TextRenderingMode.allCases, ys) {

                try context.withNewGState {
                    context.textRenderingMode = mode
                    let text = String(describing: mode)
                    try context.show(text: text, atX: 100, y: y)

                    switch mode {
                    case .fillClipping, .strokeClipping, .fillStrokeClipping, .clipping:
                        drawStripePattern(in: context, rect: Rectangle(x: 100,
                                                                       y: y,
                                                                       width: context.textWidth(for: text),
                                                                       height: context.fontCapHeight))
                    default:
                        break
                    }
                }
            }
        }

        // Then
        XCTAssertEqual(expectedInitialMode, returnedInitialMode)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }

    func testCharacterSpacing() throws {

        // Given
        let expectedInitialSpacing: Float = 0

        // When
        var returnedInitialSpacing: Float?

        try document.addPage { context in

            returnedInitialSpacing = context.characterSpacing
            context.fontSize = 7

            let ys = sequence(first: 100, next: { $0 + 1.2 * context.fontSize })
            let spacings = stride(from: -7 as Float,
                                  to: 7,
                                  by: 1)

            for (spacing, y) in zip(spacings, ys) {
                context.characterSpacing = spacing

                try context.show(text: "All work and no play makes Jack a dull boy", atX: 170, y: y)
            }
        }

        // Then
        XCTAssertEqual(expectedInitialSpacing, returnedInitialSpacing)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }

    func testWordSpacing() throws {

        // Given
        let expectedInitialSpacing: Float = 0

        // When
        var returnedInitialSpacing: Float?

        try document.addPage { context in

            returnedInitialSpacing = context.wordSpacing
            context.fontSize = 7

            let ys = sequence(first: 100, next: { $0 + 1.2 * context.fontSize })
            let spacings = stride(from: DrawingContext.minWordSpacing,
                                  to: 30,
                                  by: 1)

            for (spacing, y) in zip(spacings, ys) {
                context.wordSpacing = spacing

                try context.show(text: "All work and no play makes Jack a dull boy", atX: 160, y: y)
            }
        }

        // Then
        XCTAssertEqual(expectedInitialSpacing, returnedInitialSpacing)
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    // MARK: - Text Showing
    
    func testShowOnelineText() throws {

        // When
        try document.addPage { context in
            try context.show(text: "Hello World!", atX: 100, y: 100)
            try context.show(text: "", atX: 100, y: 200)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testShowMultilineText() throws {
        
        // When
        try document.addPage { context in
            context.textLeading = 11
            try context.show(text: "Roses are red,\nViolets are blue,\nSugar is sweet,\nAnd so are you.",
                             atX: 100, y: 200)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testShowUnicodeText() throws {

        // Given
        let fontData = getTestingResource(fromFile: "Andale Mono", ofType: "ttf")!
        let loadedFont = try document.loadTrueTypeFont(from: fontData, embeddingGlyphData: true)
        
        // When
        try document.addPage { context in

            context.textLeading = 11
            context.font = loadedFont
            context.encoding = .utf8
            
            try context.show(text: "Math poetry!", atX: 100, y: 220)
            
            try context.show(text: """
            Гомоморфный образ группы,
            (Будь во имя коммунизма)
            Изоморфен фактор-группе
            По ядру гомоморфизма.
            """, atX: 100, y: 200)
            
            // Test that setting a multibyte encoding twice doesn't cause an error in LibHaru
            context.encoding = .utf8
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }

    func testShowTextInRect() throws {

        // Given
        let text = """
        Lorem ipsum
        dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
        incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
        exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
        dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \
        Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit \
        anim id est laborum.
        """

        // When
        var result1: (isSufficientSpace: Bool, charactersPrinted: Int)!
        var result2: (isSufficientSpace: Bool, charactersPrinted: Int)!

        try document.addPage { context in

            context.textLeading = 11

            // Center alignment, insufficient space

            let rectangle1 = Rectangle(x: 100, y: 100, width: 200, height: 100)

            context.stroke(Path().appendingRectangle(rectangle1))

            result1 = try context.show(text: text, in: rectangle1, alignment: .center)

            // Justified, sufficient space

            let rectangle2 = Rectangle(x: 350, y: 100, width: 200, height: 200)

            context.stroke(Path().appendingRectangle(rectangle2))

            result2 = try context.show(text: text, in: rectangle2, alignment: .justify)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")

        XCTAssertEqual(result1.charactersPrinted, 284)
        XCTAssertFalse(result1.isSufficientSpace)

        XCTAssertEqual(result2.charactersPrinted, text.count)
        XCTAssertTrue(result2.isSufficientSpace)
    }

    func testShowWithTextMatrix() throws {

        // Given
        let matrices = [
            AffineTransform.identity,
            AffineTransform(translationX: 210, y: 160).scaled(byX: 1, y: 2),
            AffineTransform(translationX: 210, y: 220).rotated(byAngle: .pi / 6),
            AffineTransform(a: 1, b: tan(.pi / 18), c: tan(.pi / 9), d: 1, tx: 210, ty: 280),
        ]

        // When
        try document.addPage { context in

            let ys = sequence(first: 100 as Float, next: { $0 + 60 })
            for (matrix, y) in zip(matrices, ys) {
                try context.show(text: "Hello World!", atX: 200, y: y, textMatrix: matrix)
            }
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
}
