//
//  Font.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 07.10.16.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

public struct Font: Hashable {
    
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

extension Font: CustomStringConvertible {
    
    public var description: String {
        return name
    }
}
