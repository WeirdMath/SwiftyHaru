//
//  TestHelpers.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import Foundation
import XCTest

extension XCTestCase {

    var currentTestCaseName: String {
        return String(describing: type(of: self))
    }

    var currentTestName: String {
        
        // Since on Apple platforms `self.name` is optional
        // and of format `-[XCTestCaseSubclassName testMethodName]`,
        // and on other platforms it is non-optional
        // and of format `XCTestCaseSubclassName.testMethodName`
        // we have this workaround in order to unify the names
        
        return name
            .components(separatedBy: currentTestCaseName)
            .last!
            .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }
    
    func saveReferenceFile(_ data: Data, ofType type: String) {
        
        let destinationURL = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/")
            .appendingPathComponent(currentTestName + (type.isEmpty ? "" : "." + type))
        
        do {
            try data.write(to: destinationURL)
        } catch {
            XCTFail(String(describing: error))
            return
        }
        
        XCTFail("Test ran in record mode. Reference image is now saved. " +
            "Disable record mode to perform an actual resource comparison!")
    }
    
    func getURLForTestingResource(forFile file: String, ofType type: String?) -> URL? {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/")
            .appendingPathComponent(file + (type == nil ? "" : "." + type!))
    }
    
    func getTestingResource(fromFile file: String, ofType type: String?) -> Data? {
        
        guard let url = getURLForTestingResource(forFile: file, ofType: type) else { return nil }
        
        return try? Data(contentsOf: url)
    }
}
