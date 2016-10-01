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

    var currentTestName: String {
        
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            let name = self.name!
        #endif
        
        return "\(type(of: self))." +
            name.replacingOccurrences(of: "^-\\[.*\\s|]", with: "", options: .regularExpression)
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
        
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
            return try? Data(contentsOf: url)
        #else
            // FIXME: `try? Data(contentsOf: url)` causes segmentation fault in Linux
            // (probably https://bugs.swift.org/browse/SR-1547)
            if let nsdata = try? NSData(contentsOfFile: url.path, options: []) {
                return Data(referencing: nsdata)
            } else {
                return nil
            }
        #endif
    }
}
