//
//  PDFPage.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

import CLibHaru

/// A class that is used to manipulate an individual page.
public final class PDFPage {

    /// The default width of a page when you don't specify its size.
    public static let defaultWidth: Float = HPDF_DEF_PAGE_WIDTH

    /// The default height of a page when you don't specify its size.
    public static let defaultHeight: Float = HPDF_DEF_PAGE_HEIGHT

    /// The minimum allowed page height.
    public static let minHeight = Float(HPDF_MIN_PAGE_HEIGHT)

    /// The maximum allowed page height.
    public static let maxHeight = Float(HPDF_MAX_PAGE_HEIGHT)

    /// The minimum allowed page width.
    public static let minWidth = Float(HPDF_MIN_PAGE_WIDTH)

    /// The maximum allowed page width.
    public static let maxWidth = Float(HPDF_MAX_PAGE_WIDTH)

    public private(set) weak var document: PDFDocument?
    internal private(set) var _pageHandle: HPDF_Page

    internal init(document: PDFDocument, haruObject: HPDF_Page) {
        self.document = document
        _pageHandle = haruObject
    }
    
    // MARK: - Page layout
    
    /// The width of the page. The valid values are between `PDFPage.minWidth` and `PDFPage.maxWidth`.
    public var width: Float {
        get {
            return HPDF_Page_GetWidth(_pageHandle)
        }
        set {
            precondition(newValue >= PDFPage.minWidth && newValue <= PDFPage.maxWidth,
                         "The valid values for width are between `PDFPage.minWidth` and `PDFPage.maxWidth`.")
            HPDF_Page_SetWidth(_pageHandle, newValue)
        }
    }
    
    /// The height of the page. The valid values are between `PDFPage.minHeight` and `PDFPage.maxHeight`.
    public var height: Float {
        get {
            return HPDF_Page_GetHeight(_pageHandle)
        }
        set {
            precondition(newValue >= PDFPage.minHeight && newValue <= PDFPage.maxHeight,
                         "The valid values for height are between `PDFPage.minHeight` and `PDFPage.maxHeight`.")
            HPDF_Page_SetHeight(_pageHandle, newValue)
        }
    }
    
    /// Changes the size and direction of a page to a predefined size.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    public func set(size: PDFPage.Size, direction: PDFPage.Direction) {
        
        HPDF_Page_SetSize(_pageHandle,
                          HPDF_PageSizes(size.rawValue),
                          HPDF_PageDirection(direction.rawValue))
    }
    
    /// Sets rotation angle of the page.
    ///
    /// - parameter angle: The rotation angle of the page. It must be a multiple of 90 degrees. It can
    ///                    also be negative.
    public func rotate(byAngle angle: Int) {
        
        precondition(angle % 90 == 0, "The rotation angle must be a multiple of 90 degrees.")
                
        HPDF_Page_SetRotate(_pageHandle, HPDF_UINT16((angle % 360 + 360) % 360))
    }
}
