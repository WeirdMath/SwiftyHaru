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

final class GridTests: TestCase {
    
    static let allTests = [
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
        ("testCustomRightLabels", testCustomRightLabels)
    ]

    func testDrawDefaultGrid() throws {

        // Given
        let grid = Grid(width: 400, height: 600)
        
        // When
        try document.addPage { context in
            try context.draw(grid, x: 100, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomVerticalMajorLines() throws {

        // Given
        let parameters = Grid.MajorLineParameters(lineWidth: 3, lineSpacing: 20, lineColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
        
        let lines1 = Grid.Lines(verticalMajor: parameters, drawVerticalMajorLinesFirst: true)
        let gridWithVerticalMajorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(verticalMajor: parameters, drawVerticalMajorLinesFirst: false)
        let gridWithVerticalMajorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithVerticalMajorLinesDrawnFirst, x: 100, y: 100)
            try context.draw(gridWithVerticalMajorLinesDrawnLater, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomHorizontalMajorLines() throws {

        // Given
        let parameters = Grid.MajorLineParameters(lineWidth: 3, lineSpacing: 30, lineColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        
        let lines1 = Grid.Lines(horizontalMajor: parameters, drawVerticalMajorLinesFirst: false)
        let gridWithHorizontalMajorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(horizontalMajor: parameters, drawVerticalMajorLinesFirst: true)
        let gridWithHorizontalMajorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithHorizontalMajorLinesDrawnFirst, x: 100, y: 100)
            try context.draw(gridWithHorizontalMajorLinesDrawnLater, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomVerticalMinorLines() throws {

        // Given
        let parameters = Grid.MinorLineParameters(lineWidth: 1, minorSegmentsPerMajorSegment: 3, lineColor: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        
        let lines1 = Grid.Lines(verticalMinor: parameters, drawVerticalMinorLinesFirst: true)
        let gridWithVerticalMinorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(verticalMinor: parameters, drawVerticalMinorLinesFirst: false)
        let gridWithVerticalMinorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithVerticalMinorLinesDrawnFirst, x: 100, y: 100)
            try context.draw(gridWithVerticalMinorLinesDrawnLater, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomHorizontalMinorLines() throws {

        // Given
        let parameters = Grid.MinorLineParameters(lineWidth: 0.7, minorSegmentsPerMajorSegment: 4, lineColor: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        
        let lines1 = Grid.Lines(horizontalMinor: parameters, drawVerticalMinorLinesFirst: false)
        let gridWithHorizontalMinorLinesDrawnFirst = Grid(width: 200, height: 200, lines: lines1)
        
        let lines2 = Grid.Lines(horizontalMinor: parameters, drawVerticalMinorLinesFirst: true)
        let gridWithHorizontalMinorLinesDrawnLater = Grid(width: 200, height: 200, lines: lines2)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithHorizontalMinorLinesDrawnFirst, x: 100, y: 100)
            try context.draw(gridWithHorizontalMinorLinesDrawnLater, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomTopSerifs() throws {

        // Given
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: parameters, bottom: nil, left: nil, right: nil)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        try document.addPage { context in
            try context.draw(grid, x: 100, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomBottomSerifs() throws {

        // Given
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: nil, bottom: parameters, left: nil, right: nil)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        try document.addPage { context in
            try context.draw(grid, x: 100, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomLeftSerifs() throws {

        // Given

        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: nil, bottom: nil, left: parameters, right: nil)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        try document.addPage { context in
            try context.draw(grid, x: 100, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomRightSerifs() throws {

        // Given
        let parameters = Grid.SerifParameters(frequency: 2, width: 2, length: 10, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        let serifs = Grid.Serifs(top: nil, bottom: nil, left: nil, right: parameters)
        let grid = Grid(width: 200, height: 200, serifs: serifs)
        
        // When
        try document.addPage { context in
            try context.draw(grid, x: 100, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomTopLabels() throws {

        // Given
        let parametersNonReversed = Grid.LabelParameters(sequence: ["", "1", "10", "100", "1000"],
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 2,
                                                         offset: Vector(dx: 2, dy: -10),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: parametersNonReversed, bottom: nil, left: nil, right: nil)
        let labelsReversed = Grid.Labels(top: parametersReversed, bottom: nil, left: nil, right: nil)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithNonReversedLabels, x: 100, y: 100)
            try context.draw(gridWithReversedLabels, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomBottomLabels() throws {

        // Given
        let parametersNonReversed = Grid.LabelParameters(sequence: ["A", "B", "C", "D", "E"],
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 2,
                                                         offset: Vector(dx: -2, dy: -7),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: nil, bottom: parametersNonReversed, left: nil, right: nil)
        let labelsReversed = Grid.Labels(top: nil, bottom: parametersReversed, left: nil, right: nil)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithNonReversedLabels, x: 100, y: 100)
            try context.draw(gridWithReversedLabels, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomLeftLabels() throws {

        // Given
        let sequence1 = sequence(first: 0.1, next: { $0 + 0.1 }).lazy.map { String(format: "%.1f", $0) }
        let sequence2 = sequence(first: 0.1, next: { $0 + 0.1 }).lazy.map { String(format: "%.1f", $0) }
        let parametersNonReversed = Grid.LabelParameters(sequence: "" + sequence1,
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 1,
                                                         offset: Vector(dx: 5, dy: 0),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.sequence = "" + sequence2
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: nil, bottom: nil, left: parametersNonReversed, right: nil)
        let labelsReversed = Grid.Labels(top: nil, bottom: nil, left: parametersReversed, right: nil)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithNonReversedLabels, x: 100, y: 100)
            try context.draw(gridWithReversedLabels, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
    
    func testCustomRightLabels() throws {

        // Given
        let parametersNonReversed = Grid.LabelParameters(sequence: ["0", "1", "2"],
                                                         font: .timesBold,
                                                         fontSize: 5,
                                                         fontColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
                                                         frequency: 2,
                                                         offset: Vector(dx: 5, dy: 0),
                                                         reversed: false)
        var parametersReversed = parametersNonReversed
        parametersReversed.reversed = true
        
        let labelsNonReversed = Grid.Labels(top: nil, bottom: nil, left: nil, right: parametersNonReversed)
        let labelsReversed = Grid.Labels(top: nil, bottom: nil, left: nil, right: parametersReversed)
        
        let gridWithNonReversedLabels = Grid(width: 200, height: 200, labels: labelsNonReversed)
        let gridWithReversedLabels = Grid(width: 200, height: 200, labels: labelsReversed)
        
        // When
        try document.addPage { context in
            try context.draw(gridWithNonReversedLabels, x: 100, y: 100)
            try context.draw(gridWithReversedLabels, x: 350, y: 100)
        }

        // Then
        assertPDFSnapshot()
        assertPDFImageSnapshot(page: 1, named: "1")
    }
}
