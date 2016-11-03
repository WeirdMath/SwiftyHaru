//
//  PDFDocumentTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import XCTest
import Foundation
@testable import SwiftyHaru

class PDFDocumentTests: XCTestCase {
    
    static var allTests : [(String, (PDFDocumentTests) -> () throws -> Void)] {
        return [
            ("testCreateEmptyDocument", testCreateEmptyDocument),
            ("testAddingPages", testAddingPages),
            ("testPageLayout", testPageLayout),
            ("testAddPageLabel", testAddPageLabel),
            ("testLoadTrueTypeFont", testLoadTrueTypeFont),
            ("testLoadTrueTypeFontFromCollection", testLoadTrueTypeFontFromCollection)
        ]
    }
    
    var recordMode = false
    
    var sut: PDFDocument!
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        
        sut = PDFDocument()
    }
    
    override func tearDown() {
        
        if recordMode {
            saveReferenceFile(sut.getData(), ofType: "pdf")
        }
        
        sut = nil
        
        super.tearDown()
    }
    
    func testCreateEmptyDocument() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testAddingPages() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        sut.addPage()
        sut.addPage(width: 100, height: 100)
        sut.addPage(size: .a4, direction: .landscape)
        sut.insertPage(atIndex: 3)
        sut.insertPage(size: .a3, direction: .portrait, atIndex: 0)
        sut.insertPage(width: 30, height: 30, atIndex: 2)
        
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testPageLayout() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let expectedPageLayout = PDFDocument.PageLayout.twoColumnRight
        
        // When
        sut.addPage()
        sut.addPage()
        sut.addPage()
        sut.addPage()
        
        // Then
        XCTAssertEqual(.default, sut.pageLayout)
        
        // When
        sut.pageLayout = .twoColumnRight
        let returnedPageLayout = sut.pageLayout
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedPageLayout, returnedPageLayout)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testAddPageLabel() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        
        // When
        for _ in 0...8 {
            sut.addPage()
        }
        
        sut.addPageLabel(.lowerRoman, fromPage: 0, startingWith: 1)
        sut.addPageLabel(.decimal, fromPage: 4, startingWith: 1)
        sut.addPageLabel(.decimal, fromPage: 7, startingWith: 8, withPrefix: "A-")
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
    }
    
    func testLoadTrueTypeFont() {
        
        // Given
        let expectedFont = Font(name: "AndaleMono")
        
        // When
        let fontData = getTestingResource(fromFile: "Andale Mono", ofType: "ttf")!
        let loadedFont = try! sut.loadTrueTypeFont(from: fontData, embeddingGlyphData: true)
        
        // Then
        XCTAssertEqual(expectedFont, loadedFont)
        
        // When
        let incorrectFontData = Data()
        
        // Then
        XCTAssertThrowsError(try sut.loadTrueTypeFont(from: incorrectFontData, embeddingGlyphData: true))
    }
    
    func testLoadTrueTypeFontFromCollection() {
        
        // Given
        let expectedFont = Font(name: "AvenirNext-Regular")
        
        // When
        let collectionData = getTestingResource(fromFile: "Avenir Next", ofType: "ttc")!
        let loadedFont = try! sut.loadTrueTypeFontFromCollection(from: collectionData,
                                                                 index: 7,
                                                                 embeddingGlyphData: true)
        
        // Then
        XCTAssertEqual(expectedFont, loadedFont)
        
        // When
        let incorrectData = Data()
        
        // Then
        XCTAssertThrowsError(try sut.loadTrueTypeFontFromCollection(from: incorrectData,
                                                                    index: 0,
                                                                    embeddingGlyphData: true))
        
        XCTAssertThrowsError(try sut.loadTrueTypeFontFromCollection(from: collectionData,
                                                                    index: 100,
                                                                    embeddingGlyphData: true))
    }
}
