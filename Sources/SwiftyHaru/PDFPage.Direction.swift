//
//  PDFPageDirection.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

public extension PDFPage {
    
    /// Orientation of a page.
    public enum Direction: UInt32 {
        
        /// The width is less than the height.
        case portrait
        
        /// The height is less than the width.
        case landscape
    }
}

internal extension PDFPage.Direction {
    
    internal init?(haruEnum: HPDF_PageDirection) {
        self.init(rawValue: haruEnum.rawValue)
    }
}
