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
