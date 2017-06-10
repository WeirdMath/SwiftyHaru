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
#if SWIFT_PACKAGE
import CLibHaru
#endif

class PDFDocumentTests: XCTestCase {
    
    static var allTests : [(String, (PDFDocumentTests) -> () throws -> Void)] {
        return [
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

    func testSetCompressionMode() {

        // Given
        let expectedBitmask: HPDF_BOOL = 0b00000011

        // When
        let validCompressionMode: PDFDocument.CompressionMode = [.image, .text]

        do {
            try sut.setCompressionMode(to: validCompressionMode)
        } catch {
            XCTFail(String(describing: error))
        }

        let compressionModeSet = sut._documentHandle.pointee.compression_mode

        // Then
        XCTAssertEqual(expectedBitmask, compressionModeSet)

        // When
        let invalidCompressionMode = PDFDocument.CompressionMode(rawValue: 1024)

        // Then
        XCTAssertThrowsError(try sut.setCompressionMode(to: invalidCompressionMode)) { error in
            XCTAssertEqual(PDFError.invalidCompressionMode, error as? PDFError)
        }
    }

    func testSetPassword() {

//        recordMode = true

        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let ownerPassword = "12345678"
        let userPassword = "abcdefgh"
        let page = sut.addPage()

        page.draw { context in
            context.show(text: "Encrypted PDF.", atX: 200, y: 200)
        }

        XCTAssertThrowsError(try sut.setEncryptionMode(to: .r2)) { error in
            XCTAssertEqual(PDFError.documentEncryptionDictionaryNotFound, error as? PDFError)
        }

        XCTAssertThrowsError(try sut.setPassword(owner: "")) { error in
            XCTAssertEqual(PDFError.encryptionInvalidPassword, error as? PDFError)
        }

        // When
        do {
            try sut.setPassword(owner: ownerPassword, user: userPassword)
            try sut.setEncryptionMode(to: .r2)
        } catch {
            XCTFail(String(describing: error))
        }

        let returnedDocumentData = sut.getData()

        // Then

        // We can't compare the bytes because encryption is used PRGs, so we just count them.
        XCTAssertEqual(expectedDocumentData?.count, returnedDocumentData.count)
    }

    func testSetPermissions() {

//        recordMode = true

        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let ownerPassword = "12345678"
        let userPassword = "abcdefgh"
        let page = sut.addPage()

        page.draw { context in
            context.show(text: "Encrypted PDF with permissions.", atX: 200, y: 200)
        }

        XCTAssertThrowsError(try sut.setPermissions(to: .read)) { error in
            XCTAssertEqual(PDFError.documentEncryptionDictionaryNotFound, error as? PDFError)
        }

        // When
        do {
            try sut.setPassword(owner: ownerPassword, user: userPassword)
            try sut.setPermissions(to: [])
            try sut.setEncryptionMode(to: .r3(keyLength: 8))
        } catch {
            XCTFail(String(describing: error))
        }

        let returnedDocumentData = sut.getData()

        // Then

        // We can't compare the bytes because encryption is used PRGs, so we just count them.
        XCTAssertEqual(expectedDocumentData?.count, returnedDocumentData.count)
    }
    
    func testSetAuthor() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let author = "John Appleseed"
        XCTAssertNil(sut.author)
        sut.addPage()
        
        // When
        sut.author = author
        let returnedAuthor = sut.author
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(author, returnedAuthor)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
        
        // When
        sut.author = nil
        
        // Then
        XCTAssertNil(sut.author)
    }
    
    func testSetCreator() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let creator = "Takeshi Kanno"
        XCTAssertNil(sut.creator)
        sut.addPage()
        
        // When
        sut.creator = creator
        let returnedCreator = sut.creator
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(creator, returnedCreator)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
        
        // When
        sut.creator = nil
        
        // Then
        XCTAssertNil(sut.author)
    }
    
    func testSetTitle() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let title = "Hello World"
        XCTAssertNil(sut.title)
        sut.addPage()
        
        // When
        sut.title = title
        let returnedTitle = sut.title
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(title, returnedTitle)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
        
        // When
        sut.title = nil
        
        // Then
        XCTAssertNil(sut.title)
    }
    
    func testSetSubject() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let subject = "LibHaru"
        XCTAssertNil(sut.subject)
        sut.addPage()
        
        // When
        sut.subject = subject
        let returnedSubject = sut.subject
        let returnedDocumentData = sut.getData()
        
        // Then
        XCTAssertEqual(subject, returnedSubject)
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
        
        // When
        sut.subject = nil
        
        // Then
        XCTAssertNil(sut.subject)
    }
    
    func testSetKeywords() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let keywords = [
            "The Alan ParsonsProject",
            "Genesis",
            "Yes",
            "Pink Floyd"
        ]
        XCTAssertNil(sut.subject)
        sut.addPage()
        
        // When
        sut.keywords = keywords
        let returnedKeywords = sut.keywords
        let returnedDocumentData = sut.getData()
        
        // Then
        if let returnedKeywords = returnedKeywords {
            XCTAssertEqual(keywords, returnedKeywords)
        } else {
            XCTFail()
        }
        
        XCTAssertEqual(expectedDocumentData, returnedDocumentData)
        
        // When
        sut.keywords = nil
        
        // Then
        XCTAssertNil(sut.keywords)
        
        // When
        sut.keywords = []
        
        // Then
        if let keywords = sut.keywords {
            XCTAssertEqual(keywords, [])
        } else {
            XCTFail()
        }
    }
    
    func testSetCreationDate() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let date = Date(timeIntervalSince1970: 1_497_055_314)
        XCTAssertNil(sut.creationDate)
        sut.addPage()
        
        // When
        sut.timeZone = TimeZone(identifier: "America/Los_Angeles")!
        sut.creationDate = date
        let returnedDateWithLosAngelesTimeZone = sut.creationDate
        let returnedDocumentDataWithLosAngelesTimeZone = sut.getData()
        
        // Then
        XCTAssertEqual(date, returnedDateWithLosAngelesTimeZone)
        XCTAssertEqual(expectedDocumentData, returnedDocumentDataWithLosAngelesTimeZone)
        
        // When
        sut.timeZone = TimeZone(secondsFromGMT: 0)!
        let returnedDateWithGMTTimeZone = sut.creationDate
        let returnedDocumentDataWithGMTTimeZone = sut.getData()
        
        // Then
        XCTAssertEqual(date, returnedDateWithGMTTimeZone)
        XCTAssertNotEqual(expectedDocumentData, returnedDocumentDataWithGMTTimeZone)
        
        // When
        sut.creationDate = nil
        
        // Then
        XCTAssertNil(sut.creationDate)
    }
    
    func testSetModificationDate() {
        
//        recordMode = true
        
        // Given
        let expectedDocumentData = getTestingResource(fromFile: currentTestName, ofType: "pdf")
        let date = Date(timeIntervalSince1970: 1_497_055_314)
        XCTAssertNil(sut.modificationDate)
        sut.addPage()
        
        // When
        sut.timeZone = TimeZone(identifier: "America/Los_Angeles")!
        sut.modificationDate = date
        let returnedDateWithLosAngelesTimeZone = sut.modificationDate
        let returnedDocumentDataWithLosAngelesTimeZone = sut.getData()
        
        // Then
        XCTAssertEqual(date, returnedDateWithLosAngelesTimeZone)
        XCTAssertEqual(expectedDocumentData, returnedDocumentDataWithLosAngelesTimeZone)
        
        // When
        sut.timeZone = TimeZone(secondsFromGMT: 0)!
        let returnedDateWithGMTTimeZone = sut.modificationDate
        let returnedDocumentDataWithGMTTimeZone = sut.getData()
        
        // Then
        XCTAssertEqual(date, returnedDateWithGMTTimeZone)
        XCTAssertNotEqual(expectedDocumentData, returnedDocumentDataWithGMTTimeZone)
        
        // When
        sut.modificationDate = nil
        
        // Then
        XCTAssertNil(sut.modificationDate)
    }
}
