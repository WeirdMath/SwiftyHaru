//
//  TestHelpers.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import Foundation
import XCTest
import SwiftyHaru
import SnapshotTesting

#if canImport(Cocoa)
import Cocoa
#elseif canImport(UIKit)
import UIKit
#endif

#if os(Linux)
typealias SnapshotTestCase = SnapshotTesting.SnapshotTestCase
#else
typealias SnapshotTestCase = XCTestCase
#endif

#if canImport(Cocoa) || canImport(UIKit)
private func ImageFromPDF(_ pdf: Data, page index: Int) -> CocoaImage {
    let dataProvider = CGDataProvider(data: pdf as CFData)!
    let document = CGPDFDocument(dataProvider)!
    let page = document.page(at: index)!
    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = CocoaGraphicsImageRenderer(size: pageRect.size)
    return renderer.image { context in
        CocoaColor.white.set()
        context.fill(pageRect)
        context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        context.cgContext.drawPDFPage(page)
    }
}
#endif

extension Diffing where Value == Data {

    static let pdf = Diffing(toData: { $0 }, fromData: { $0 }) { old, new in
        Diffing<String>.lines.diff(String(decoding: old, as: UTF8.self), String(decoding: new, as: UTF8.self))
    }

#if canImport(Cocoa) || canImport(UIKit)
    static func pdfImage(page index: Int, precision: Float) -> Diffing {
        return Diffing(toData: { $0 }, fromData: { $0 }) { old, new in
            let imageDiffing = Snapshotting<CocoaImage, CocoaImage>.image(precision: precision).diffing
            return imageDiffing.diff(ImageFromPDF(old, page: index), ImageFromPDF(new, page: index))
        }
    }
#endif

    static let byteCount = Diffing(toData: { $0 }, fromData: { $0 }) { old, new in
        guard old.count != new.count else { return nil }

        let attachments: [XCTAttachment]

        // FIXME: Remove this when https://github.com/pointfreeco/swift-snapshot-testing/pull/159 is merged
        #if !os(Linux)
        attachments = [XCTAttachment(data: old), XCTAttachment(data: new)]
        #else
        attachments = []
        #endif

        return ("Expected \(new) to match \(old)", attachments)
    }
}

extension Snapshotting where Value == SwiftyHaru.PDFDocument, Format == Data {

    static let pdf = Snapshotting(pathExtension: "pdf", diffing: .pdf, snapshot: { $0.getData() })

#if canImport(Cocoa) || canImport(UIKit)
    static func pdfImage(page index: Int, precision: Float) -> Snapshotting {
        return Snapshotting(pathExtension: "pdf",
                            diffing: .pdfImage(page: index, precision: precision),
                            snapshot: { $0.getData() })
    }
#endif

    static let byteCount = Snapshotting(pathExtension: "pdf", diffing: .byteCount, snapshot: { $0.getData() })
}

class TestCase: SnapshotTestCase {

    var document: SwiftyHaru.PDFDocument!

    override func setUp() {
        super.setUp()

        document = PDFDocument()
    }

    override func tearDown() {

        document = nil

        super.tearDown()
    }

    var testCaseName: String {
        return String(describing: type(of: self))
    }

    var testMethodName: String {
        // Since on Apple platforms `self.name` is optional
        // and of format `-[XCTestCaseSubclassName testMethodName]`,
        // and on other platforms it is non-optional
        // and of format `XCTestCaseSubclassName.testMethodName`
        // we have this workaround in order to unify the names

        return name
            .components(separatedBy: testCaseName)
            .last!
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }

    var currentTestName: String {
        return "\(testCaseName).\(testMethodName)"
    }

    func assertPDFSnapshot(named name: String? = nil,
                           record recording: Bool = false,
                           timeout: TimeInterval = 5,
                           file: StaticString = #file,
                           testName: String = #function,
                           line: UInt = #line) {

        assertSnapshot(matching: document!,
                       as: .pdf,
                       named: name,
                       record: recording,
                       timeout: timeout,
                       file: file,
                       testName: testName,
                       line: line)
    }

    func assertPDFImageSnapshot(page index: Int,
                                precision: Float = 1,
                                named name: String? = nil,
                                record recording: Bool = false,
                                timeout: TimeInterval = 5,
                                file: StaticString = #file,
                                testName: String = #function,
                                line: UInt = #line) {
#if canImport(Cocoa) || canImport(UIKit)
        assertSnapshot(matching: document!,
                       as: .pdfImage(page: index, precision: precision),
                       named: name,
                       record: recording,
                       timeout: timeout,
                       file: file,
                       testName: testName,
                       line: line)

#endif
    }
        
    private func _getURLForTestingResource(forFile file: String, ofType type: String?) -> URL? {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/")
            .appendingPathComponent(file + (type == nil ? "" : "." + type!))
    }
    
    final func getTestingResource(fromFile file: String, ofType type: String?) -> Data? {
        
        guard let url = _getURLForTestingResource(forFile: file, ofType: type) else { return nil }
        
        return try? Data(contentsOf: url)
    }
}
