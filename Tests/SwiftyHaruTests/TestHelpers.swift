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

#if os(Linux)
typealias SnapshotTestCase = SnapshotTesting.SnapshotTestCase
#else
typealias SnapshotTestCase = XCTestCase
#endif

extension Diffing where Value == Data {

    static let pdf = Diffing(toData: { $0 }, fromData: { $0 }) { old, new in
        Diffing<String>.lines.diff(String(decoding: old, as: UTF8.self), String(decoding: new, as: UTF8.self))
    }

    static let byteCount = Diffing(toData: { $0 }, fromData: { $0 }) { old, new in
        guard old.count != new.count else { return nil }
        return ("Expected \(new) to match \(old)", [XCTAttachment(data: old), XCTAttachment(data: new)])
    }
}

extension Snapshotting where Value == PDFDocument, Format == Data {

    static let pdf = Snapshotting(pathExtension: "pdf", diffing: .pdf, snapshot: { $0.getData() })

    static let byteCount = Snapshotting(pathExtension: "pdf", diffing: .byteCount, snapshot: { $0.getData() })
}

class TestCase: SnapshotTestCase {

    var document: PDFDocument!

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
