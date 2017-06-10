//
//  DashStyle.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 06.10.16.
//
//

#if SWIFT_PACKAGE
import typealias CLibHaru.HPDF_DashMode
import typealias CLibHaru.HPDF_UINT16
import var CLibHaru.HPDF_MAX_DASH_PATTERN
#endif

/// Dash pattern for lines in a page.
public struct DashStyle {
    
    /// Straight line without dash.
    ///
    /// ![Figure](http://libharu.org/figures/figure16.png "figure")
    public static var straightLine = DashStyle(pattern: [])!
    
    public static var maxDashPattern = Int(HPDF_MAX_DASH_PATTERN)
    
    /// Pattern of dashes and gaps used to stroke paths.
    public var pattern: [Int]
    
    /// The phase in which the pattern begins (default is 0).
    public var phase: Int
    
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
            pattern.count == 1 || pattern.count & 1 == 0,
            phase >= 0 else { return nil }
        
        for i in pattern where i <= 0 || i > DashStyle.maxDashPattern {
            return nil
        }
        
        self.phase = phase
        self.pattern = pattern
    }
}

extension DashStyle: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: DashStyle, rhs: DashStyle) -> Bool {
        return lhs.pattern == rhs.pattern && lhs.phase == rhs.phase
    }
}

internal extension DashStyle {
    
    internal init(_ haruStruct: HPDF_DashMode) {
    
        // `haruStruct.ptn` is represented as a tuple in Swift. Since we cannot iterate over a tuple directly,
        // we use reflection to get the values.
        
        let mirror = Mirror(reflecting: haruStruct.ptn)
        let extendedPattern = mirror.children.map { Int($0.value as! HPDF_UINT16) }
        pattern = Array(extendedPattern.prefix(upTo: Int(haruStruct.num_ptn)))
        phase = Int(haruStruct.phase)
    }
}
