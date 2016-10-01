//
//  PDFPage.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

public final class PDFPage: _HaruBridgeable {
    
    internal var _haruObject: HPDF_Page
    
    internal init(haruObject: HPDF_Page) {
        _haruObject = haruObject
    }
    
    /// The width of the page. Valid values are between 3 and 14400.
    public var width: Float {
        get {
            return HPDF_Page_GetWidth(_haruObject)
        }
        set {
            HPDF_Page_SetWidth(_haruObject, newValue)
        }
    }
    
    /// The height of the page. Valid values are between 3 and 14400.
    public var height: Float {
        get {
            return HPDF_Page_GetHeight(_haruObject)
        }
        set {
            HPDF_Page_SetHeight(_haruObject, newValue)
        }
    }
    
    /// Changes the size and direction of a page to a predefined size.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    ///
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    public func set(size: PDFPage.Size, direction: PDFPage.Direction) throws {
        HPDF_Page_SetSize(_haruObject, HPDF_PageSizes(size.rawValue), HPDF_PageDirection(direction.rawValue))
    }
}
