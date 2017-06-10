//
//  PDFPageDirection.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

public extension PDFPage {
    
    public enum Direction: UInt32 {
        
        case portrait
        
        case landscape
    }
}

internal extension PDFPage.Direction {
    
    internal init?(haruEnum: HPDF_PageDirection) {
        self.init(rawValue: haruEnum.rawValue)
    }
}
