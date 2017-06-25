//
//  PDFDocument.PageLayout.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

public extension PDFDocument {
    
    /// Determines how pages in the document should be displayed.
    public enum PageLayout: UInt32 {
        
        /// Only one page is displayed.
        case single
        
        /// Display the pages in one column.
        case oneColumn
        
        /// Display in two columns. Odd page number is displayed left.
        case twoColumnLeft
        
        /// Display in two columns. Odd page number is displayed right.
        case twoColumnRight
        
        case twoPageLeft
        
        case twoPageRight
        
        /// The setting of the viewer application is used.
        case `default`
    }
}

internal extension PDFDocument.PageLayout {
    
    internal init(haruEnum: HPDF_PageLayout) {
        self.init(rawValue: haruEnum.rawValue)!
    }
}
