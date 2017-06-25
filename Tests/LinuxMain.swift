import XCTest
@testable import SwiftyHaruTests

XCTMain([
    testCase(PDFDocumentTests.allTests),
    testCase(PDFPageTests.allTests),
    testCase(ColorTests.allTests),
    testCase(DrawingContextTests.allTests),
    testCase(DashStyleTests.allTests),
    testCase(GridTests.allTests),
    testCase(PDFDateFormatterTests.allTests)
])
