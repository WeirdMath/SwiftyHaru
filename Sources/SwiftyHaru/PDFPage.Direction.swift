//
//  PDFPageDirection.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

extension PDFPage {
    
    /// Orientation of a page.
    public enum Direction: UInt32, CaseIterable {
        
        /// The width is less than the height.
        case portrait
        
        /// The height is less than the width.
        case landscape
    }
}
