//
//  DashStyle.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 06.10.16.
//
//

import typealias CLibHaru.HPDF_DashMode
import typealias CLibHaru.HPDF_UINT16
import var CLibHaru.HPDF_MAX_DASH_PATTERN

/// Dash pattern for lines in a page.
public struct DashStyle: Hashable {
    
    /// Straight line without dash.
    ///
    /// ![Figure](http://libharu.org/figures/figure16.png "figure")
    public static var straightLine = DashStyle(pattern: [])!
    
    public static let maxDashPattern = Int(HPDF_MAX_DASH_PATTERN)
    
    /// Pattern of dashes and gaps used to stroke paths.
    public let pattern: [Int]
    
    /// The phase in which the pattern begins (default is 0).
    public let phase: Int
    
    /// Creates a dash style for lines.
    ///
    /// - parameter pattern: Pattern of dashes and gaps used to stroke paths.
    ///                      Must contain only positive integers less than or equal to `DashStyle.maxDashPattern`;
    ///                      `pattern.count` must be an even number less than 9, or 1.
    /// - parameter phase:   The phase in which the pattern begins (default is 0). Must be nonnegative.
    ///
    /// - returns: A dash style for lines.
    public init?(pattern: [Int], phase: Int = 0) {
        
        guard pattern.count <= 8,
            pattern.count == 1 || pattern.count % 2 == 0,
            phase >= 0 else { return nil }

        guard !pattern.contains(where: { $0 <= 0 || $0 > DashStyle.maxDashPattern }) else {
            return nil
        }

        self.phase = phase
        self.pattern = pattern
    }
}

extension DashStyle {
    
    internal init(_ haruStruct: HPDF_DashMode) {
    
        pattern = withUnsafePointer(to: haruStruct.ptn) { pattern in
            pattern.withMemoryRebound(to: HPDF_UINT16.self, capacity: Int(haruStruct.num_ptn)) { pattern in
                UnsafeBufferPointer(start: pattern, count: Int(haruStruct.num_ptn)).map(Int.init)
            }
        }
        
        phase = Int(haruStruct.phase)
    }
}
