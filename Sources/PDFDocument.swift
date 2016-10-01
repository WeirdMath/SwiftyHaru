//
//  PDFDocument.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 30.09.16.
//
//

import CLibHaru

public final class PDFDocument: _HaruBridgeable {
    
    internal var _haruObject: HPDF_Doc
    
    public private(set) var pages: [PDFPage] = []
    
    internal var _error: PDFError
    
    /// Creates an instance of a document object.
    ///
    /// - returns: An instance of a document object or `nil` on failure.
    public init?() {
        
        _error = PDFError(code: HPDF_OK)
        
        func errorHandler(errorCode: HPDF_STATUS,
                          detailCode: HPDF_STATUS,
                          userData: UnsafeMutableRawPointer?) {
            
            let error = userData?.assumingMemoryBound(to: PDFError.self)
            error?.pointee = PDFError(code: Int32(errorCode))
        }
        
        guard let document = HPDF_New(errorHandler, &_error) else { return nil }
        
        _haruObject = document
    }
    
    deinit {
        HPDF_Free(_haruObject)
    }
    
    /// Creates a new page and adds it after the last page of the document.
    ///
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    ///
    /// - returns: A `PDFPage` object.
    public func addPage() throws -> PDFPage {
        
        guard let haruPage = HPDF_AddPage(_haruObject) else { throw _error }
        
        let page = PDFPage(document: self, haruObject: haruPage)
        pages.append(page)
        
        return page
    }
    
    /// Creates a new page of the specified width and height and adds it after the last page of the document.
    ///
    /// - parameter width: The width of the page.
    /// - parameter height: The height of the page.
    ///
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    ///
    /// - returns: A `PDFPage` object.
    public func addPage(width: Float, height: Float) throws -> PDFPage {
        
        let page = try addPage()
        
        page.width = width
        page.height = height
        
        return page
    }
    
    /// Creates a new page of the specified size and direction and adds it after the last page of the document.
    ///
    /// - parameter size:      A predefined page-size value.
    /// - parameter direction: The direction of the page.
    ///
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    ///
    /// - returns: A `PDFPage` object.
    public func addPage(size: PDFPage.Size, direction: PDFPage.Direction) throws -> PDFPage {
        
        let page = try addPage()
        
        try page.set(size: size, direction: direction)
        
        return page
    }
    
    /// Creates a new page and inserts it just before the page with the specified index.
    ///
    /// - parameter index: The index at which the new page will appear. `index` must be a valid index
    ///                    of the array `pages` or equal to its `endIndex` property.
    ///
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    ///
    /// - returns: A `PDFPage` object.
    public func insertPage(atIndex index: Int) throws -> PDFPage {
        
        if index == pages.endIndex {
            return try addPage()
        }
        
        let haruTargetPage = pages[index]._haruObject
        
        guard let haruInsertedPage = HPDF_InsertPage(_haruObject, haruTargetPage) else { throw _error }
        
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
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    ///
    /// - returns: A `PDFPage` object.
    func insertPage(width: Float, height: Float, atIndex index: Int) throws -> PDFPage {
        
        let page = try insertPage(atIndex: index)
        
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
    /// - throws: `PDFError.failedToAllocateMemory` if memory allocation fails.
    ///
    /// - returns: A `PDFPage` object.
    public func insertPage(size: PDFPage.Size,
                           direction: PDFPage.Direction,
                           atIndex index: Int) throws -> PDFPage {
        
        let page = try insertPage(atIndex: index)
        
        try page.set(size: size, direction: direction)
        
        return page
    }
}
