//
//  Font.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 07.10.16.
//
//

import CLibHaru

public struct Font {
    
    public let name: String
    
    public static let courier              = Font(name: "Courier")
    
    public static let courierBold          = Font(name: "Courier-Bold")
    
    public static let courierOblique       = Font(name: "Courier-Oblique")
    
    public static let courierBoldOblique   = Font(name: "Courier-BoldOblique")
    
    public static let helvetica            = Font(name: "Helvetica")
    
    public static let helveticaBold        = Font(name: "Helvetica-Bold")
    
    public static let helveticaOblique     = Font(name: "Helvetica-Oblique")
    
    public static let helveticaBoldOblique = Font(name: "Helvetica-BoldOblique")
    
    public static let timesRoman           = Font(name: "Times-Roman")
    
    public static let timesBold            = Font(name: "Times-Bold")
    
    public static let timesItalic          = Font(name: "Times-Italic")
    
    public static let timesBoldItalic      = Font(name: "Times-BoldItalic")
    
    public static let symbol               = Font(name: "Symbol")
    
    public static let zapfDingbats         = Font(name: "ZapfDingbats")
}

extension Font: Hashable {
    
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return name.hashValue
    }
}

extension Font: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Font, rhs: Font) -> Bool {
        return lhs.name == rhs.name
    }
}
