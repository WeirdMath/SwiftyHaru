//
//  PDFPathContext.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 02.10.16.
//
//

import CLibHaru

public final class PDFPathContext {
    
    private var _page: HPDF_Page
    
    internal init(for page: HPDF_Page) {
        _page = page
    }
    
    internal func finalize() {
        
        // If by the this method is called the `_page` object's graphics mode is not HPDF_GMODE_PAGE_DESCRIPTION,
        // one of the path painting operators is invoked automatically during this method call.
        // Also during this method call all the graphics properties of the page like line width or stroke color
        // are set to their default values.
        
        if Int32(HPDF_Page_GetGMode(_page)) != HPDF_GMODE_PAGE_DESCRIPTION {
            HPDF_Page_Stroke(_page)
        }
        
        // Reset to default values
        lineWidth = 1
    }
    
    /// The current line width for path painting of the page. Default value is 1.
    public var lineWidth: Float {
        get {
            return HPDF_Page_GetLineWidth(_page)
        }
        set {
            HPDF_Page_SetLineWidth(_page, newValue)
        }
    }
}
