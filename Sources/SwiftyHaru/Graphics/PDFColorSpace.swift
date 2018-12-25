//
//  PDFColorSpace.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.10.16.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

/// A profile that specifies how to interpret a color value for display.
public enum PDFColorSpace: UInt32, CaseIterable {
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

extension PDFColorSpace {
    
    internal init(haruEnum: HPDF_ColorSpace) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
