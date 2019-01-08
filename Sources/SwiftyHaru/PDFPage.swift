//
//  PDFPage.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 01.10.16.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

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

    internal var mediaBox: Rectangle {
        get {
            guard let arrayHandle = HPDF_Page_GetInheritableItem(_pageHandle,
                                                                 "MediaBox",
                                                                 HPDF_UINT16(HPDF_OCLASS_ARRAY)) else {
                preconditionFailure("The page must contain the MediaBox entry")
            }

            let array = PDFArray(handle: arrayHandle.assumingMemoryBound(to: _HPDF_Array_Rec.self))

            guard let rect = Rectangle(decoding: array) else {
                preconditionFailure("The MediaBox entry must be a rectangle")
            }

            return rect
        }
        set {
            guard let arrayHandle = HPDF_Page_GetInheritableItem(_pageHandle,
                                                                 "MediaBox",
                                                                 HPDF_UINT16(HPDF_OCLASS_ARRAY)) else {
                preconditionFailure("The page must contain the MediaBox entry")
            }

            let array = PDFArray(handle: arrayHandle.assumingMemoryBound(to: _HPDF_Array_Rec.self))
            precondition(array.count == 4 &&
                         array[0] as UnsafeMutableRawPointer? != nil &&
                         array[1] as UnsafeMutableRawPointer? != nil &&
                         array[2] as UnsafeMutableRawPointer? != nil &&
                         array[3] as UnsafeMutableRawPointer? != nil,
                         "The MediaBox entry must be a rectangle")
            array[0]?.pointee.value = newValue.x
            array[1]?.pointee.value = newValue.y
            array[2]?.pointee.value = newValue.width
            array[3]?.pointee.value = newValue.height
        }
    }
    
    /// The width of the page. The valid values are between `PDFPage.minWidth` and `PDFPage.maxWidth`.
    public var width: Float {
        get {
            return mediaBox.width
        }
        set {
            precondition(newValue >= PDFPage.minWidth && newValue <= PDFPage.maxWidth,
                         "The valid values for width are between `PDFPage.minWidth` and `PDFPage.maxWidth`.")
            mediaBox.size.width = newValue
        }
    }
    
    /// The height of the page. The valid values are between `PDFPage.minHeight` and `PDFPage.maxHeight`.
    public var height: Float {
        get {
            return mediaBox.height
        }
        set {
            precondition(newValue >= PDFPage.minHeight && newValue <= PDFPage.maxHeight,
                         "The valid values for height are between `PDFPage.minHeight` and `PDFPage.maxHeight`.")
            mediaBox.size.height = newValue
        }
    }
    
    /// Changes the size and direction of a page to a predefined size.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    public func set(size: PDFPage.Size, direction: PDFPage.Direction) {
        switch direction {
        case .portrait:
            height = size.sizeInPixels.height
            width = size.sizeInPixels.width
        case .landscape:
            height = size.sizeInPixels.width
            width = size.sizeInPixels.height
        }
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
