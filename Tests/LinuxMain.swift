import XCTest
@testable import SwiftyHaruTests

XCTMain([
     testCase(PDFDocumentTests.allTests),
     testCase(PDFPageTests.allTests)
])
