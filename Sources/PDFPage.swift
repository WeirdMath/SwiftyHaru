//
//  PDFPage.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

/// A handle that is used to manipulate an individual page.
public final class PDFPage: _HaruBridgeable {
    
    public unowned var document: PDFDocument
    
    internal var _haruObject: HPDF_Page
    
    internal init(document: PDFDocument, haruObject: HPDF_Page) {
        self.document = document
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
        
        let success = HPDF_Page_SetSize(_haruObject,
                                        HPDF_PageSizes(size.rawValue),
                                        HPDF_PageDirection(direction.rawValue))
        
        if success != UInt(HPDF_OK) {
            throw document._error
        }
    }
    
    /// Sets rotation angle of the page.
    ///
    /// - parameter angle: The rotation angle of the page. It must be a multiple of 90 degrees. It can
    ///                    also be negative.
    ///
    /// - throws: `PDFError.pageInvalidRotateValue` if an invalid rotation angle was set.
    public func rotate(byAngle angle: Int) throws {
        
        let success = HPDF_Page_SetRotate(_haruObject, HPDF_UINT16((angle % 360 + 360) % 360))
        
        if success != UInt(HPDF_OK) {
            throw document._error
        }
    }
}
