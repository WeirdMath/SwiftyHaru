//
//  GridTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 05.11.16.
//
//

import XCTest
import Foundation
@testable import SwiftyHaru

class GridTests: XCTestCase {
    
    static var allTests: [(String, (GridTests) -> () throws -> Void)] {
        return [
            ("testDrawDefaultGrid", testDrawDefaultGrid),
            ("testCustomVerticalMajorLines", testCustomVerticalMajorLines),
            ("testCustomHorizontalMajorLines", testCustomHorizontalMajorLines),
            ("testCustomVerticalMinorLines", testCustomVerticalMinorLines),
            ("testCustomHorizontalMinorLines", testCustomHorizontalMinorLines),
            ("testCustomTopSerifs", testCustomTopSerifs),
            ("testCustomBottomSerifs", testCustomBottomSerifs),
            ("testCustomLeftSerifs", testCustomLeftSerifs),
            ("testCustomRightSerifs", testCustomRightSerifs),
            ("testCustomTopLabels", testCustomTopLabels),
            ("testCustomBottomLabels", testCustomBottomLabels),
            ("testCustomLeftLabels", testCustomLeftLabels),
            ("testCustomRightLabels", testCustomRightLabels),
            ("testGridsEquality", testGridsEquality)
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
    
    func testDrawDefaultGrid() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let grid = Grid(width: 400, height: 600)
        
        // When
        page.draw(object: grid, x: 100, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomVerticalMajorLines() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.MajorLineParameters(lineWidth: 3, lineSpacing: 20, lineColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
        
        let lines1 = Grid.Lines(verticalMajor: parameters, drawVerticalMajorLinesFirst: true)
        let gridWithVerticalMajorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(verticalMajor: parameters, drawVerticalMajorLinesFirst: false)
        let gridWithVerticalMajorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        page.draw(object: gridWithVerticalMajorLinesDrawnFirst, x: 100, y: 100)
        page.draw(object: gridWithVerticalMajorLinesDrawnLater, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomHorizontalMajorLines() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.MajorLineParameters(lineWidth: 3, lineSpacing: 30, lineColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        
        let lines1 = Grid.Lines(horizontalMajor: parameters, drawVerticalMajorLinesFirst: false)
        let gridWithHorizontalMajorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(horizontalMajor: parameters, drawVerticalMajorLinesFirst: true)
        let gridWithHorizontalMajorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        page.draw(object: gridWithHorizontalMajorLinesDrawnFirst, x: 100, y: 100)
        page.draw(object: gridWithHorizontalMajorLinesDrawnLater, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomVerticalMinorLines() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.MinorLineParameters(lineWidth: 1, minorSegmentsPerMajorSegment: 3, lineColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        
        let lines1 = Grid.Lines(verticalMinor: parameters, drawVerticalMinorLinesFirst: true)
        let gridWithVerticalMinorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(verticalMinor: parameters, drawVerticalMinorLinesFirst: false)
        let gridWithVerticalMinorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        page.draw(object: gridWithVerticalMinorLinesDrawnFirst, x: 100, y: 100)
        page.draw(object: gridWithVerticalMinorLinesDrawnLater, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomHorizontalMinorLines() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.MinorLineParameters(lineWidth: 0.7, minorSegmentsPerMajorSegment: 4, lineColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        
        let lines1 = Grid.Lines(horizontalMinor: parameters, drawVerticalMinorLinesFirst: false)
        let gridWithHorizontalMinorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(horizontalMinor: parameters, drawVerticalMinorLinesFirst: true)
        let gridWithHorizontalMinorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        page.draw(object: gridWithHorizontalMinorLinesDrawnFirst, x: 100, y: 100)
        page.draw(object: gridWithHorizontalMinorLinesDrawnLater, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomTopSerifs() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: parameters, bottom: nil, left: nil, right: nil)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        page.draw(object: grid, x: 100, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomBottomSerifs() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: nil, bottom: parameters, left: nil, right: nil)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        page.draw(object: grid, x: 100, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomLeftSerifs() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: nil, bottom: nil, left: parameters, right: nil)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        page.draw(object: grid, x: 100, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomRightSerifs() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: nil, bottom: nil, left: nil, right: parameters)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        page.draw(object: grid, x: 100, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomTopLabels() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parametersNonReversed = Grid.LabelParameters(sequence: ["", "1", "10", "100", "1000"],
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 2,
                                                         offset: Vector(x: 2, y: -10),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: parametersNonReversed, bottom: nil, left: nil, right: nil)
        let labelsReversed = Grid.Labels(top: parametersReversed, bottom: nil, left: nil, right: nil)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        page.draw(object: gridWithNonReversedLabels, x: 100, y: 100)
        page.draw(object: gridWithReversedLabels, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomBottomLabels() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parametersNonReversed = Grid.LabelParameters(sequence: ["A", "B", "C", "D", "E"],
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 2,
                                                         offset: Vector(x: -2, y: -7),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: nil, bottom: parametersNonReversed, left: nil, right: nil)
        let labelsReversed = Grid.Labels(top: nil, bottom: parametersReversed, left: nil, right: nil)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        page.draw(object: gridWithNonReversedLabels, x: 100, y: 100)
        page.draw(object: gridWithReversedLabels, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomLeftLabels() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let sequence1 = sequence(first: 0.1, next: { $0 + 0.1 }).lazy.map(String.init)
        let sequence2 = sequence(first: 0.1, next: { $0 + 0.1 }).lazy.map(String.init)
        let parametersNonReversed = Grid.LabelParameters(sequence: "" + sequence1,
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 1,
                                                         offset: Vector(x: 5, y: 0),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.sequence = "" + sequence2
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: nil, bottom: nil, left: parametersNonReversed, right: nil)
        let labelsReversed = Grid.Labels(top: nil, bottom: nil, left: parametersReversed, right: nil)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        page.draw(object: gridWithNonReversedLabels, x: 100, y: 100)
        page.draw(object: gridWithReversedLabels, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testCustomRightLabels() {
        
        //        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        let parametersNonReversed = Grid.LabelParameters(sequence: ["0", "1", "2"],
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 2,
                                                         offset: Vector(x: 5, y: 0),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: nil, bottom: nil, left: nil, right: parametersNonReversed)
        let labelsReversed = Grid.Labels(top: nil, bottom: nil, left: nil, right: parametersReversed)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        page.draw(object: gridWithNonReversedLabels, x: 100, y: 100)
        page.draw(object: gridWithReversedLabels, x: 350, y: 100)
        let returnedDocumentData = document.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testGridsEquality() {
        
        // Given
        
        let verticalMajor = Grid.MajorLineParameters(lineWidth: 11,
                                                     lineSpacing: 34,
                                                     lineColor: .red)
        let horizontalMajor = Grid.MajorLineParameters(lineWidth: 355,
                                                       lineSpacing: 1,
                                                       lineColor: .blue)
        let horizontalMinor = Grid.MinorLineParameters(lineWidth: 1,
                                                       minorSegmentsPerMajorSegment: 30,
                                                       lineColor: .white)
        let lines = Grid.Lines(verticalMajor: verticalMajor,
                               horizontalMajor: horizontalMajor,
                               verticalMinor: nil,
                               horizontalMinor: horizontalMinor,
                               drawVerticalMajorLinesFirst: false,
                               drawVerticalMinorLinesFirst: true)
        
        let topSerifs = Grid.SerifParameters(frequency: 1, width: 10, length: 200, color: .black)
        let bottomSerifs = Grid.SerifParameters(frequency: 32, width: 5, length: 1, color: .red)
        let leftSerifs = Grid.SerifParameters(frequency: 3, width: 12, length: 4, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        
        let serifs = Grid.Serifs(top: topSerifs, bottom: bottomSerifs, left: leftSerifs, right: nil)
        
        let labelParameters1 = Grid.LabelParameters(sequence: ["0", "1", "2", "0"],
                                                    font: .courier,
                                                    fontSize: 3,
                                                    fontColor: .green,
                                                    frequency: 5,
                                                    offset: Vector(x: 10, y: -4),
                                                    reversed: true)
        
        var labelParameters2 = labelParameters1
        labelParameters2.reversed = false
        
        let labels1 = Grid.Labels(top: nil, bottom: labelParameters1, left: labelParameters1, right: nil)
        let labels2 = Grid.Labels(top: nil, bottom: labelParameters2, left: labelParameters2, right: nil)
        
        let grid1 = Grid(width: 101, height: 404, lines: lines, labels: labels1, serifs: serifs)
        let grid2 = Grid(width: 101, height: 404, lines: lines, labels: labels1, serifs: serifs)
        let grid3 = Grid(width: 101, height: 404, lines: lines, labels: labels2, serifs: serifs)
        
        // Then
        XCTAssertEqual(grid1, grid2)
        XCTAssertEqual(grid2, grid1)
        XCTAssertNotEqual(grid2, grid3)
        XCTAssertNotEqual(grid3, grid2)
        XCTAssertNotEqual(grid1, grid3)
        XCTAssertNotEqual(grid3, grid1)
    }
}
