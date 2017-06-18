//
//  PDFPageDirection.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

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
