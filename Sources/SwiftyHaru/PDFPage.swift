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
public final class PDFPage {
    
    public weak var document: PDFDocument?
    
    private var __pageHandle: HPDF_Page
    
    internal var _pageHandle: HPDF_Page {
        if document == nil {
            fatalError("The document that owns the page has been deallocated")
        }
        
        return __pageHandle
    }
    
    internal init(document: PDFDocument, haruObject: HPDF_Page) {
        self.document = document
        __pageHandle = haruObject
    }
    
    // MARK: - Page layout
    
    /// The width of the page. Valid values are between 3 and 14400. Setting an invalid value makes no change.
    public var width: Float {
        get {
            return HPDF_Page_GetWidth(_pageHandle)
        }
        set {
            if newValue >= 3 && newValue <= 14400 {
                HPDF_Page_SetWidth(_pageHandle, newValue)
            }
        }
    }
    
    /// The height of the page. Valid values are between 3 and 14400. Setting an invalid value makes no change.
    public var height: Float {
        get {
            return HPDF_Page_GetHeight(_pageHandle)
        }
        set {
            if newValue >= 3 && newValue <= 14400 {
                HPDF_Page_SetHeight(_pageHandle, newValue)
            }
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
    ///
    /// - throws: `PDFError.pageInvalidRotateValue` if an invalid rotation angle was set.
    public func rotate(byAngle angle: Int) throws {
        
        guard angle % 90 == 0 else {
            throw PDFError.pageInvalidRotateValue
        }
        
        HPDF_Page_SetRotate(_pageHandle, HPDF_UINT16((angle % 360 + 360) % 360))
    }
    
    // MARK: - Graphics
    
    // In libHaru, each page object maintains a flag named "graphics mode".
    // The graphics mode corresponds to the graphics-object of the PDF specification.
    // The graphics mode is changed by invoking particular functions.
    // The functions that can be invoked are decided by the value of the graphics mode.
    // The following figure shows the relationships of the graphics mode.
    //
    //     +=============================+
    //     / HPDF_GMODE_PAGE_DESCRIPTION /
    //     /                             /<-------------------------------+
    //     / Allowed operators:          /                                |
    //     / * General graphics state    /                                |
    //     / * Special graphics state    /-----------------+      +---------------------+
    //     / * Color                     /                 |      | HPDF_Page_EndText() |
    //     +=============================+                 |      +---------------------+
    //             |                ^                      |              |
    //             |                |        +-----------------------+    |
    // +-----------------------+    |        | HPDF_Page_BeginText() |    |
    // | HPDF_Page_MoveTo()    |    |        +-----------------------+    |
    // | HPDF_Page_Rectangle() |    |                      |              |
    // | HPDF_Page_Arc()       |    |                      V              |
    // | HPDF_Page_Circle()    |    |                +========================+
    // +-----------------------+    |                / HPDF_GMODE_TEXT_OBJECT /
    //             |                |                /                        /
    //             |   +-------------------------+   / Allowed operators      /
    //             |   | Path Painting Operators |   / * Graphics state       /
    //             |   +-------------------------+   / * Color                /
    //             |                |                / * Text state           /
    //             V                |                / * Text-showing         /
    //     +=============================+           / * Text-positioning     /
    //     / HPDF_GMODE_PATH_OBJECT      /           +========================+
    //     /                             /
    //     / Allowed operators:          /
    //     / * Path construction         /
    //     +=============================+
    //
    // In SwiftyHaru we don't want the make the user maintain this state machine manually,
    // so there are context objects like PDFPathContext which maintain it automatically.
    // So each graphics mode except HPDF_GMODE_PAGE_DESCRIPTION is entered only within a closure.
    //
    // We invoke `draw(_:)` method with a closure that takes a context object and performs path construction
    // or text creation on the context object which is implicitly connected with the page object.
    // Also during `_cleanup()` method call all the graphics properties of the page like line width or stroke color
    // are set to their default values.
    
    /// Perform path drawing operations on the page.
    ///
    /// - Warning: The `PDFPathContext` argument should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    ///
    /// - Precondition: No drawing context must be present for this current page, i. e. you cannot run the
    ///   following code:
    ///
    /// ```swift
    /// page.drawPath { context in
    ///
    ///     self.page.drawPath { innerContext in
    ///         // do things
    ///     }
    /// }
    /// ```
    ///
    /// - parameter body: The closure that takes a context object. Perform drawing operations on that object.
    public func draw(_ body: ((DrawingContext) -> Void)) {
        
        if _contextIsPresent {
            preconditionFailure("Cannot begin a new drawing context while the previous one is not revoked.")
        }
        
        _contextIsPresent = true
        
        let context = DrawingContext(for: _pageHandle)
        
        context._cleanup()
        
        body(context)
        
        context._cleanup()
        
        context._invalidate()
        
        _contextIsPresent = false
    }
    
    private var _contextIsPresent = false
}
