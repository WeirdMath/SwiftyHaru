//
//  PDFColorSpace.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.10.16.
//
//

import CLibHaru

/// A profile that specifies how to interpret a color value for display.
public enum PDFColorSpace: UInt32 {
    case deviceGray
    case deviceRGB
    case deviceCMYK
    case calGray
    case calRGB
    case lab
    case iccBased
    case separation
    case deviceN
    case indexed
    case pattern
    case undefined
}

internal extension PDFColorSpace {
    
    internal init(haruEnum: HPDF_ColorSpace) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
