//
//  PDFPage.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

/// A handle that is used to manipulate an individual page.
///
/// - Warning: If the `PDFDocument` object that owns the page is deallocated, accessing the page's properties
///            will cause a crash. The lifetime of a page should always be shorter than the lifetime of
///            the document that owns the page.
public final class PDFPage: _HaruBridgeable {
    
    public weak var document: PDFDocument?
    
    private var _pageHandle: HPDF_Page
    
    internal var _haruObject: HPDF_Page {
        if document == nil {
            fatalError("The document that owns the page has been deallocated")
        }
        
        return _pageHandle
    }
    
    internal init(document: PDFDocument, haruObject: HPDF_Page) {
        self.document = document
        _pageHandle = haruObject
    }
    
    /// The width of the page. Valid values are between 3 and 14400. Setting an invalid value makes no change.
    public var width: Float {
        get {
            return HPDF_Page_GetWidth(_haruObject)
        }
        set {
            if newValue >= 3 || newValue <= 14400 {
                HPDF_Page_SetWidth(_haruObject, newValue)
            }
        }
    }
    
    /// The height of the page. Valid values are between 3 and 14400. Setting an invalid value makes no change.
    public var height: Float {
        get {
            return HPDF_Page_GetHeight(_haruObject)
        }
        set {
            if newValue >= 3 || newValue <= 14400 {
                HPDF_Page_SetHeight(_haruObject, newValue)
            }
        }
    }
    
    /// Changes the size and direction of a page to a predefined size.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    public func set(size: PDFPage.Size, direction: PDFPage.Direction) {
        
        HPDF_Page_SetSize(_haruObject,
                                        HPDF_PageSizes(size.rawValue),
                                        HPDF_PageDirection(direction.rawValue))
    }
    
    /// Sets rotation angle of the page.
    ///
    /// - parameter angle: The rotation angle of the page. It must be a multiple of 90 degrees. It can
    ///                    also be negative.
    ///
    /// - throws: `PDFError.pageInvalidRotateValue` if an invalid rotation angle was set.
    public func rotate(byAngle angle: Int) throws {
        
        let success = HPDF_Page_SetRotate(_haruObject, HPDF_UINT16((angle % 360 + 360) % 360))
        
        if success != HPDF_STATUS(HPDF_OK) {
            
            if let document = document {
                HPDF_ResetError(document._haruObject)
            }
            
            throw PDFError(code: Int32(success))
        }
    }
}
