//
//  PDFDocumentTests.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import XCTest
import Foundation
import SnapshotTesting
@testable import SwiftyHaru
#if SWIFT_PACKAGE
import CLibHaru
#endif

final class PDFDocumentTests: TestCase {
    
    static let allTests = [
        ("testCreateEmptyDocument", testCreateEmptyDocument),
        ("testAddingPages", testAddingPages),
        ("testPageLayout", testPageLayout),
        ("testAddPageLabel", testAddPageLabel),
        ("testLoadTrueTypeFont", testLoadTrueTypeFont),
        ("testLoadTrueTypeFontFromCollection", testLoadTrueTypeFontFromCollection),
        ("testSetCompressionMode", testSetCompressionMode),
        ("testSetPassword", testSetPassword),
        ("testSetPermissions", testSetPermissions),
        ("testSetAuthor", testSetAuthor),
        ("testSetCreator", testSetCreator),
        ("testSetTitle", testSetTitle),
        ("testSetSubject", testSetSubject),
        ("testSetKeywords", testSetKeywords),
        ("testSetCreationDate", testSetCreationDate),
        ("testSetModificationDate", testSetModificationDate)
    ]

    func testCreateEmptyDocument() {
        assertPDFSnapshot()
    }
    
    func testAddingPages() {

        // When
        document.addPage()
        document.addPage(width: 100, height: 100)
        document.addPage(size: .a4, direction: .landscape)
        document.insertPage(atIndex: 3)
        document.insertPage(size: .a3, direction: .portrait, atIndex: 0)
        document.insertPage(width: 30, height: 30, atIndex: 2)

        // Then
        assertPDFSnapshot()
    }
    
    func testPageLayout() {

        // Given
        let expectedPageLayout = PDFDocument.PageLayout.twoColumnRight
        
        // When
        document.addPage()
        document.addPage()
        document.addPage()
        document.addPage()
        
        // Then
        XCTAssertEqual(.default, document.pageLayout)
        
        // When
        document.pageLayout = .twoColumnRight
        let returnedPageLayout = document.pageLayout

        // Then
        XCTAssertEqual(expectedPageLayout, returnedPageLayout)
        assertPDFSnapshot()
    }
    
    func testAddPageLabel() {

        // Given
        for _ in 0...8 {
            document.addPage()
        }

        // When
        document.addPageLabel(.lowerRoman, fromPage: 0, startingWith: 1)
        document.addPageLabel(.decimal, fromPage: 4, startingWith: 1)
        document.addPageLabel(.decimal, fromPage: 7, startingWith: 8, withPrefix: "A-")

        // Then
        assertPDFSnapshot()
    }
    
    func testLoadTrueTypeFont() throws {
        
        // Given
        let expectedFont = Font(name: "AndaleMono")
        
        // When
        let fontData = getTestingResource(fromFile: "Andale Mono", ofType: "ttf")!
        let loadedFont = try document.loadTrueTypeFont(from: fontData, embeddingGlyphData: true)
        
        // Then
        XCTAssertEqual(expectedFont, loadedFont)
        
        // When
        let incorrectFontData = Data()
        
        // Then
        XCTAssertThrowsError(try document.loadTrueTypeFont(from: incorrectFontData, embeddingGlyphData: true))
    }
    
    func testLoadTrueTypeFontFromCollection() throws {
        
        // Given
        let expectedFont = Font(name: "AvenirNext-Regular")
        
        // When
        let collectionData = getTestingResource(fromFile: "Avenir Next", ofType: "ttc")!
        let loadedFont = try document.loadTrueTypeFontFromCollection(from: collectionData,
                                                                     index: 7,
                                                                     embeddingGlyphData: true)
        
        // Then
        XCTAssertEqual(expectedFont, loadedFont)
        
        // When
        let incorrectData = Data()
        
        // Then
        XCTAssertThrowsError(try document.loadTrueTypeFontFromCollection(from: incorrectData,
                                                                         index: 0,
                                                                         embeddingGlyphData: true))
        
        XCTAssertThrowsError(try document.loadTrueTypeFontFromCollection(from: collectionData,
                                                                         index: 100,
                                                                         embeddingGlyphData: true))
    }

    func testSetCompressionMode() throws {

        // Given
        let expectedBitmask: HPDF_BOOL = 0b00000011

        // When
        let validCompressionMode: PDFDocument.CompressionMode = [.image, .text]

        try document.setCompressionMode(to: validCompressionMode)

        let compressionModeSet = document._documentHandle.pointee.compression_mode

        // Then
        XCTAssertEqual(expectedBitmask, compressionModeSet)

        // When
        let invalidCompressionMode = PDFDocument.CompressionMode(rawValue: 1024)

        // Then
        XCTAssertThrowsError(try document.setCompressionMode(to: invalidCompressionMode)) { error in
            XCTAssertEqual(PDFError.invalidCompressionMode, error as? PDFError)
        }
    }

    func testSetPassword() throws {

        // Given
        let ownerPassword = "12345678"
        let userPassword = "abcdefgh"
        try document.addPage { context in
            try context.show(text: "Encrypted PDF.", atX: 200, y: 200)
        }

        // When
        try document.setPassword(owner: ownerPassword, user: userPassword, encryptionMode: .r2)

        // Then
        // We can't compare the bytes because encryption uses PRGs, so we just count them.
        assertSnapshot(matching: document, as: .byteCount)
    }

    func testSetPermissions() throws {

        // Given
        let ownerPassword = "12345678"
        let userPassword = "abcdefgh"
        try document.addPage { context in
            try context.show(text: "Encrypted PDF with permissions.", atX: 200, y: 200)
        }

        // When
        try document.setPassword(owner: ownerPassword,
                                 user: userPassword,
                                 permissions: [],
                                 encryptionMode: .r3(keyLength: 8))

        // Then
        // We can't compare the bytes because encryption uses PRGs, so we just count them.
        assertSnapshot(matching: document, as: .byteCount)
    }
    
    func testSetAuthor() {

        // Given
        let author = "John Appleseed"
        document.addPage()
        
        // When
        document.metadata.author = author

        // Then
        assertPDFSnapshot()
    }
    
    func testSetCreator() {

        // Given
        let creator = "Takeshi Kanno"
        document.addPage()
        
        // When
        document.metadata.creator = creator

        // Then
        assertPDFSnapshot()
    }
    
    func testSetTitle() {

        // Given
        let title = "Hello World"
        document.addPage()
        
        // When
        document.metadata.title = title

        // Then
        assertPDFSnapshot()
    }
    
    func testSetSubject() {

        // Given
        let subject = "LibHaru"
        document.addPage()
        
        // When
        document.metadata.subject = subject

        // Then
        assertPDFSnapshot()
    }
    
    func testSetKeywords() {

        // Given
        let keywords = [
            "The Alan Parsons Project",
            "Genesis",
            "Yes",
            "Pink Floyd"
        ]
        document.addPage()
        
        // When
        document.metadata.keywords = keywords

        // Then
        assertPDFSnapshot()
    }
    
    func testSetCreationDate() {
        
//        recordMode = true

        // Given
        let date = Date(timeIntervalSince1970: 1_497_055_314)
        document.addPage()
        
        // When
        document.metadata.timeZone = TimeZone(secondsFromGMT: -25200)!
        document.metadata.creationDate = date

        // Then
        assertPDFSnapshot()
    }
    
    func testSetModificationDate() {

        // Given
        let date = Date(timeIntervalSince1970: 1_497_055_314)
        document.addPage()
        
        // When
        document.metadata.timeZone = TimeZone(secondsFromGMT: -25200)!
        document.metadata.modificationDate = date

        // Then
        assertPDFSnapshot()
    }
}
