//
//  PDFDocument.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 30.09.16.
//
//

import Foundation
import CLibHaru

/// A handle to operate on a document object.
public final class PDFDocument: _HaruBridgeable {
    
    internal var _haruObject: HPDF_Doc
    
    public private(set) var pages: [PDFPage] = []
    
    internal var _error: PDFError
    
    /// Creates an instance of a document object.
    ///
    /// - returns: An instance of a document.
    public init() {
        
        _error = PDFError(code: HPDF_OK)
        
        func errorHandler(errorCode: HPDF_STATUS,
                          detailCode: HPDF_STATUS,
                          userData: UnsafeMutableRawPointer?) {
            
            let error = userData!.assumingMemoryBound(to: PDFError.self)
            error.pointee = PDFError(code: Int32(errorCode))
            
            assertionFailure("An error in Haru. Code: \(error.pointee.code). \(error.pointee.description)")
        }
        
        _haruObject = HPDF_New(errorHandler, &_error)
    }
    
    deinit {
        HPDF_Free(_haruObject)
    }
    
    // MARK: - Creating pages
    
    /// Creates a new page and adds it after the last page of the document.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func addPage() -> PDFPage {
        
        let haruPage = HPDF_AddPage(_haruObject)!
        
        let page = PDFPage(document: self, haruObject: haruPage)
        pages.append(page)
        
        return page
    }
    
    /// Creates a new page of the specified width and height and adds it after the last page of the document.
    ///
    /// - parameter width: The width of the page.
    /// - parameter height: The height of the page.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func addPage(width: Float, height: Float) -> PDFPage {
        
        let page = addPage()
        
        page.width = width
        page.height = height
        
        return page
    }
    
    /// Creates a new page of the specified size and direction and adds it after the last page of the document.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func addPage(size: PDFPage.Size, direction: PDFPage.Direction) -> PDFPage {
        
        let page = addPage()
        
        page.set(size: size, direction: direction)
        
        return page
    }
    
    /// Creates a new page and inserts it just before the page with the specified index.
    ///
    /// - parameter index: The index at which the new page will appear. `index` must be a valid index
    ///                    of the array `pages` or equal to its `endIndex` property.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func insertPage(atIndex index: Int) -> PDFPage {
        
        if index == pages.endIndex {
            return addPage()
        }
        
        let haruTargetPage = pages[index]._haruObject
        
        let haruInsertedPage = HPDF_InsertPage(_haruObject, haruTargetPage)!
        
        let page = PDFPage(document: self, haruObject: haruInsertedPage)
        
        pages.insert(page, at: index)
        
        return page
    }
    
    /// Creates a new page of the specified width and height and inserts it just before the page
    /// with the specified index.
    ///
    /// - parameter width:  The width of the page.
    /// - parameter height: The height of the page.
    /// - parameter index:  The index at which the new page will appear. `index` must be a valid index
    ///                     of the array `pages` or equal to its `endIndex` property.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func insertPage(width: Float, height: Float, atIndex index: Int) -> PDFPage {
        
        let page = insertPage(atIndex: index)
        
        page.width = width
        page.height = height
        
        return page
    }
    
    /// Creates a new page of the specified size and direction and inserts it just before the page
    /// with the specified index.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    /// - parameter index:     The index at which the new page will appear. `index` must be a valid index
    ///                        of the array `pages` or equal to its `endIndex` property.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func insertPage(size: PDFPage.Size,
                           direction: PDFPage.Direction,
                           atIndex index: Int) -> PDFPage {
        
        let page = insertPage(atIndex: index)
        
        page.set(size: size, direction: direction)
        
        return page
    }
    
    // MARK: - Getting data

    /// Returns the document's contents.
    ///
    /// - returns: The dodument's contents
    public func getData() -> Data {
        
        HPDF_SaveToStream(_haruObject)

        let sizeOfStream = HPDF_GetStreamSize(_haruObject)
        
        HPDF_ResetStream(_haruObject)
        
        let buffer = UnsafeMutablePointer<HPDF_BYTE>.allocate(capacity: Int(sizeOfStream))
        var sizeOfBuffer = sizeOfStream
        
        HPDF_ReadFromStream(_haruObject, buffer, &sizeOfBuffer)
        
        let data = Data(bytes: buffer, count: Int(sizeOfBuffer))
        
        buffer.deinitialize(count: Int(sizeOfBuffer))
        buffer.deallocate(capacity: Int(sizeOfBuffer))

        return data
    }
    
    // MARK: - General pages parameters
    
    /// Determines how pages should be displayed.
    /// If this attribute is not set, the setting of the viewer application is used.
    public var pageLayout: PageLayout {
        get {
            return PageLayout(haruEnum: HPDF_GetPageLayout(_haruObject))
        }
        set {
            HPDF_SetPageLayout(_haruObject, HPDF_PageLayout(rawValue: newValue.rawValue))
        }
    }
    
    /// Adds a page labeling range for the document. The page label is shown in the thumbnails view.
    ///
    /// Example:
    ///
    /// ```swift
    /// document.addPageLabel(.lowerRoman, fromPage: 0, startingWith: 1)
    /// document.addPageLabel(.decimal, fromPage: 4, startingWith: 1)
    /// document.addPageLabel(.decimal, fromPage: 7, startingWith: 8, withPrefix: "A-")
    /// ```
    ///
    /// Result in a document with pages labeled:
    ///
    /// i, ii, iii, iv, 1, 2, 3, A-8, A-9, ...
    ///
    /// - parameter style:           `PDFDocument.PageNumberStyle` enum case
    /// - parameter startingPage:    The first page that applies this labeling range.
    /// - parameter firstPageNumber: The first page number to use.
    /// - parameter prefix:          The prefix for the page label. Default is `nil`.
    public func addPageLabel(_ style: PageNumberStyle,
                             fromPage startingPage: Int,
                             startingWith firstPageNumber: Int,
                             withPrefix prefix: String? = nil) {
        
        let prefix = prefix?.cString(using: .ascii)
        
        HPDF_AddPageLabel(_haruObject,
                          HPDF_UINT(startingPage),
                          HPDF_PageNumStyle(rawValue: style.rawValue),
                          HPDF_UINT(firstPageNumber),
                          prefix)
    }
}
