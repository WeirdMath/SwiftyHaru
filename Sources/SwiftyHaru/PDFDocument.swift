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
public final class PDFDocument {
    
    internal var _documentHandle: HPDF_Doc
    
    /// An array of pages in the document. Initially is empty. Use the `addPage()`, `addPage(width:height:)`,
    /// `addPage(size:direction:)` or `insertPage(atIndex:)`, `insertPage(width:height:atIndex:)`,
    /// `insertPage(size:direction:atIndex:)` methods to add pages to your document and populate this array.
    public private(set) var pages: [PDFPage] = []
    
    /// The fonts loaded in the document. Initially is empty. Use the `loadTrueTypeFont(from:embeddingGlyphData:)`
    /// or `loadTrueTypeFontFromCollection(from:index:embeddingGlyphData:)` methods to load fonts.
    ///
    /// This set does not include the base 14 fonts (see predefined values of `Font`)
    /// that can be used in the document without loading any external fonts.
    public private(set) var fonts: Set<Font> = []
    
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

            // TODO: Must be removed in 1.0.0 release
            #if DEBUG
                print("An error in Haru. Code: \(error.pointee.code). \(error.pointee.description)")
            #endif
        }
        
        _documentHandle = HPDF_New(errorHandler, &_error)
    }
    
    deinit {
        HPDF_Free(_documentHandle)
    }
    
    // MARK: - Creating pages

    private func _drawOnPage(_ page: PDFPage, _ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        let context = DrawingContext(page: page, document: self)
        defer { context._isInvalidated = true }
        try draw(context)
        return page
    }

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
    // so there are context objects of type DrawingContext which maintain it automatically.
    // So each graphics mode except HPDF_GMODE_PAGE_DESCRIPTION is entered only during certain function calls.
    //
    // We invoke the `draw` closure that takes a context object and performs path construction
    // or text creation on the context object which is connected with the page object.

    /// Creates a new page and adds it after the last page of the document.
    ///
    /// - Returns: A `PDFPage` object.
    @discardableResult
    public func addPage() -> PDFPage {
        let haruPage = HPDF_AddPage(_documentHandle)!
        let page = PDFPage(document: self, haruObject: haruPage)
        pages.append(page)
        return page
    }

    /// Creates a new page and adds it after the last page of the document.
    ///
    /// - Parameter draw: The drawing operations to perform, or `nil` if no drawing should be performed.
    /// - Returns: A `PDFPage` object.
    /// - Warning: The `DrawingContext` object should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    @discardableResult
    public func addPage(_ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        return try _drawOnPage(addPage(), draw)
    }

    /// Creates a new page of the specified width and height and adds it after the last page of the document.
    ///
    /// - Parameters:
    ///   - width: The width of the page.
    ///   - height: The height of the page.
    /// - Returns: A `PDFPage` object.
    @discardableResult
    public func addPage(width: Float,  height: Float) -> PDFPage {
        let page = addPage()
        page.width = width
        page.height = height
        return page
    }
    
    /// Creates a new page of the specified width and height and adds it after the last page of the document.
    ///
    /// - Parameters:
    ///   - width:  The width of the page.
    ///   - height: The height of the page.
    ///   - draw:   The drawing operations to perform, or `nil` if no drawing should be performed.
    /// - Returns: A `PDFPage` object.
    /// - Warning: The `DrawingContext` object should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    @discardableResult
    public func addPage(width: Float,
                        height: Float,
                        _ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        return try _drawOnPage(addPage(width: width, height: height), draw)
    }

    /// Creates a new page of the specified size and direction and adds it after the last page of the document.
    ///
    /// - Parameters:
    ///   - size:      A predefined page-size value.
    ///   - direction: The direction of the page (portrait or landscape).
    /// - Returns: A `PDFPage` object.
    @discardableResult
    public func addPage(size: PDFPage.Size,
                        direction: PDFPage.Direction) -> PDFPage {
        let page = addPage()
        page.set(size: size, direction: direction)
        return page
    }
    
    /// Creates a new page of the specified size and direction and adds it after the last page of the document.
    ///
    /// - Parameters:
    ///   - size:      A predefined page-size value.
    ///   - direction: The direction of the page (portrait or landscape).
    ///   - draw:      The drawing operations to perform, or `nil` if no drawing should be performed.
    /// - Returns: A `PDFPage` object.
    /// - Warning: The `DrawingContext` object should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    @discardableResult
    public func addPage(size: PDFPage.Size,
                        direction: PDFPage.Direction,
                        _ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        return try _drawOnPage(addPage(size: size, direction: direction), draw)
    }

    /// Creates a new page and inserts it just before the page with the specified index.
    ///
    /// - Parameter index: The index at which the new page will appear. `index` must be a valid index
    ///                    of the array `pages` or equal to its `endIndex` property.
    /// - Returns: A `PDFPage` object.
    @discardableResult
    public func insertPage(atIndex index: Int) -> PDFPage {
        if index == pages.endIndex {
            return addPage()
        }
        let haruTargetPage = pages[index]._pageHandle
        let haruInsertedPage = HPDF_InsertPage(_documentHandle, haruTargetPage)!
        let page = PDFPage(document: self, haruObject: haruInsertedPage)
        pages.insert(page, at: index)
        return page
    }
    
    /// Creates a new page and inserts it just before the page with the specified index.
    ///
    /// - Parameters:
    ///   - index: The index at which the new page will appear. `index` must be a valid index
    ///            of the array `pages` or equal to its `endIndex` property.
    ///   - draw:  The drawing operations to perform, or `nil` if no drawing should be performed.
    /// - Returns: A `PDFPage` object.
    /// - Warning: The `DrawingContext` object should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    @discardableResult
    public func insertPage(atIndex index: Int, _ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        return try _drawOnPage(insertPage(atIndex: index), draw)
    }

    /// Creates a new page of the specified width and height and inserts it just before the page
    /// with the specified index.
    ///
    /// - Parameters:
    ///   - width:  The width of the page.
    ///   - height: The height of the page.
    ///   - index:  The index at which the new page will appear. `index` must be a valid index
    ///             of the array `pages` or equal to its `endIndex` property.
    /// - Returns: A `PDFPage` object.
    @discardableResult
    public func insertPage(width: Float, height: Float, atIndex index: Int) -> PDFPage {
        let page = insertPage(atIndex: index)
        page.width = width
        page.height = height
        return page
    }
    
    /// Creates a new page of the specified width and height and inserts it just before the page
    /// with the specified index.
    ///
    /// - Parameters:
    ///   - width:  The width of the page.
    ///   - height: The height of the page.
    ///   - index:  The index at which the new page will appear. `index` must be a valid index
    ///             of the array `pages` or equal to its `endIndex` property.
    ///   - draw:   The drawing operations to perform, or `nil` if no drawing should be performed.
    /// - Returns: A `PDFPage` object.
    /// - Warning: The `DrawingContext` object should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    @discardableResult
    public func insertPage(width: Float,
                           height: Float,
                           atIndex index: Int,
                           _ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        return try _drawOnPage(insertPage(width: width, height: height, atIndex: index), draw)
    }

    /// Creates a new page of the specified size and direction and inserts it just before the page
    /// with the specified index.
    ///
    /// - Parameters:
    ///   - size:      A predefined page-size value.
    ///   - direction: The direction of the page (portrait or landscape).
    ///   - index:     The index at which the new page will appear. `index` must be a valid index
    ///                of the array `pages` or equal to its `endIndex` property.
    /// - Returns: A `PDFPage` object.
    @discardableResult
    public func insertPage(size: PDFPage.Size,
                           direction: PDFPage.Direction,
                           atIndex index: Int) -> PDFPage {
        let page = insertPage(atIndex: index)
        page.set(size: size, direction: direction)
        return page
    }
    
    /// Creates a new page of the specified size and direction and inserts it just before the page
    /// with the specified index.
    ///
    /// - Parameters:
    ///   - size:      A predefined page-size value.
    ///   - direction: The direction of the page (portrait or landscape).
    ///   - index:     The index at which the new page will appear. `index` must be a valid index
    ///                of the array `pages` or equal to its `endIndex` property.
    ///   - draw:      The drawing operations to perform, or `nil` if no drawing should be performed.
    /// - Returns: A `PDFPage` object.
    /// - Warning: The `DrawingContext` object should not be stored and used outside of the lifetime
    ///            of the call to the closure.
    @discardableResult
    public func insertPage(size: PDFPage.Size,
                           direction: PDFPage.Direction,
                           atIndex index: Int,
                           _ draw: (DrawingContext) throws -> Void) rethrows -> PDFPage {
        return try _drawOnPage(insertPage(size: size, direction: direction, atIndex: index), draw)
    }
    
    // MARK: - Getting data
    
    /// Renders the document and returns its contents.
    ///
    /// - returns: The document's contents
    public func getData() -> Data {
        
        _renderMetadata()
        
        HPDF_SaveToStream(_documentHandle)
        
        let sizeOfStream = HPDF_GetStreamSize(_documentHandle)
        
        HPDF_ResetStream(_documentHandle)
        
        let buffer = UnsafeMutablePointer<HPDF_BYTE>.allocate(capacity: Int(sizeOfStream))
        var sizeOfBuffer = sizeOfStream
        
        HPDF_ReadFromStream(_documentHandle, buffer, &sizeOfBuffer)

        let data = Data(bytes: buffer, count: Int(sizeOfBuffer))
        
        buffer.deallocate()
        
        return data
    }
    
    // MARK: - General pages parameters
    
    /// Determines how pages should be displayed.
    /// If this attribute is not set, the setting of the viewer application is used.
    public var pageLayout: PageLayout {
        get {
            return PageLayout(haruEnum: HPDF_GetPageLayout(_documentHandle))
        }
        set {
            HPDF_SetPageLayout(_documentHandle, HPDF_PageLayout(rawValue: newValue.rawValue))
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
                             withPrefix prefix: String = String()) {

        prefix.withCString { cString in
            _ = HPDF_AddPageLabel(_documentHandle,
                                  HPDF_UINT(startingPage),
                                  HPDF_PageNumStyle(rawValue: style.rawValue),
                                  HPDF_UINT(firstPageNumber),
                                  cString)
        }
    }

    // MARK: - Including fonts
    
    /// Loads a TrueType font from `data` and registers it to a document.
    ///
    /// - parameter data:               Contents of a `.ttf` file.
    /// - parameter embeddingGlyphData: If this parameter is set to `true`, the glyph data of the font is embedded,
    ///                                 otherwise only the matrix data is included in PDF file.
    ///
    /// - throws: `PDFError.invalidTTCIndex`, `PDFError.invalidTTCFile`,
    ///           `PDFError.ttfInvalidCMap`, `PDFError.ttfInvalidFormat`, `PDFError.ttfMissingTable`,
    ///           `PDFError.ttfCannotEmbedFont`.
    ///
    /// - returns: The loaded font.
    public func loadTrueTypeFont(from data: Data, embeddingGlyphData: Bool) throws -> Font {
        
        let embedding = embeddingGlyphData ? HPDF_TRUE : HPDF_FALSE
        
        let name = data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> String? in
            let cString = HPDF_LoadTTFontFromMemory(self._documentHandle,
                                                    pointer,
                                                    HPDF_UINT(data.count),
                                                    embedding)
            if let cString = cString {
                return String(cString: cString)
            } else {
                return nil
            }
        }
        
        if let name = name {
            let font = Font(name: name)
            fonts.insert(font)
            return font
        } else {
            HPDF_ResetError(_documentHandle)
            throw _error
        }
    }
    
    /// Loads a TrueType font from a TrueType Collection and registers it to a document.
    ///
    /// - parameter data:               Contents of a `.ttc` file.
    /// - parameter index:              The index of the font to be loaded.
    /// - parameter embeddingGlyphData: If this parameter is set to `true`, the glyph data of the font is embedded,
    ///                                 otherwise only the matrix data is included in PDF file.
    ///
    /// - throws: `PDFError.invalidTTCIndex`, `PDFError.invalidTTCFile`,
    ///           `PDFError.ttfInvalidCMap`, `PDFError.ttfInvalidFormat`, `PDFError.ttfMissingTable`,
    ///           `PDFError.ttfCannotEmbedFont`.
    ///
    /// - returns: The loaded font.
    public func loadTrueTypeFontFromCollection(from data: Data,
                                               index: Int,
                                               embeddingGlyphData: Bool) throws -> Font {
        
        let embedding = embeddingGlyphData ? HPDF_TRUE : HPDF_FALSE
        
        let name = data.withUnsafeBytes { (pointer: UnsafePointer<UInt8>) -> String? in
            HPDF_LoadTTFontFromMemory2(self._documentHandle,
                                       pointer,
                                       HPDF_UINT(data.count),
                                       HPDF_UINT(index),
                                       embedding).map(String.init)
        }
        
        if let name = name {
            let font = Font(name: name)
            fonts.insert(font)
            return font
        } else {
            HPDF_ResetError(_documentHandle)
            throw _error
        }
    }
    
    private var _jpEncodingsEnabled = false
    private var _krEncodingsEnabled = false
    private var _cnsEncodingsEnabled = false
    private var _cntEncodingsEnabled = false
    private var _utfEncodingsEnabled = false
    
    internal func _useJPEncodings() {
        if !_jpEncodingsEnabled {
            HPDF_UseJPEncodings(_documentHandle)
            _jpEncodingsEnabled = true
        }
    }
    
    internal func _useKREncodings() {
        if !_krEncodingsEnabled {
            HPDF_UseKREncodings(_documentHandle)
            _krEncodingsEnabled = true
        }
    }
    
    internal func _useCNSEncodings() {
        if !_cnsEncodingsEnabled {
            HPDF_UseCNSEncodings(_documentHandle)
            _cnsEncodingsEnabled = true
        }
    }
    
    internal func _useCNTEncodings() {
        if !_cntEncodingsEnabled {
            HPDF_UseCNTEncodings(_documentHandle)
            _cntEncodingsEnabled = true
        }
    }
    
    internal func _useUTFEncodings() {
        if !_utfEncodingsEnabled {
            HPDF_UseUTFEncodings(_documentHandle)
            _utfEncodingsEnabled = true
        }
    }

    // MARK: - Compression

    /// Set the mode of compression.
    ///
    /// - Parameter mode: The mode of compression (may be combined).
    /// - Throws: `PDFError.invalidCompressionMode` if the provided compression mode was invalid.
    public func setCompressionMode(to mode: CompressionMode) throws {
        if HPDF_SetCompressionMode(_documentHandle, HPDF_UINT(mode.rawValue)) != UInt(HPDF_OK) {
            HPDF_ResetError(_documentHandle)
            throw _error
        }
    }

    // MARK: - Security

    /// Sets the encryption mode. As a side effect, ups the version of PDF to 1.4
    /// when the mode is set to `.r3`.
    ///
    /// - Important: Prior to calling this method you must set the password using
    ///              the `setPassword(owner:user:)` method.
    ///
    /// - Parameter mode: The encryption mode to set.
    /// - Throws: `PDFError.invalidEncryptionKeyLength` if an invalid key length was specified;
    ///           `PDFError.documentEncryptionDictionaryNotFound` if you haven't set a password.
    private func _setEncryptionMode(to mode: EncryptionMode) throws {

        let haruMode: HPDF_EncryptMode
        let keyLength: HPDF_UINT

        switch mode {
        case .r2:
            haruMode = HPDF_ENCRYPT_R2
            keyLength = 5
        case .r3(keyLength: let length):
            haruMode = HPDF_ENCRYPT_R3

            if length < 0 { throw PDFError.invalidEncryptionKeyLength }

            keyLength = HPDF_UINT(length)
        }

        if HPDF_SetEncryptionMode(_documentHandle, haruMode, keyLength) != UInt(HPDF_OK) {

            HPDF_ResetError(_documentHandle)
            throw _error
        }
    }

    private func _setPermissions(to permissions: Permissions) throws {

        if HPDF_SetPermission(_documentHandle, HPDF_UINT(permissions.rawValue)) != UInt(HPDF_OK) {

            HPDF_ResetError(_documentHandle)
            throw _error
        }
    }

    /// Sets a password for the document. If the password is set, the document contents are encrypted.
    ///
    /// - Parameters:
    ///   - owner: The password for the owner of the document. The owner can change the permission of the document.
    ///            Zero length string and the same value as user password are not allowed.
    ///   - user: The password for the user of the document. May be set to `nil` or zero length string.
    ///   - permissions: The permission flags for the document. Default is `nil`.
    ///   - encryptionMode: The encryption mode. Ups the version of PDF to 1.4 when the mode is set to `.r3`.
    ///                     Default is `nil`.
    /// - Throws: `PDFError.encryptionInvalidPassword` if the owner password is zero length string or
    ///            same value as the user password; `PDFError.invalidEncryptionKeyLength` if an invalid key length
    ///            was specified.
    public func setPassword(owner: String,
                            user: String? = nil,
                            permissions: Permissions? = nil,
                            encryptionMode: EncryptionMode? = nil) throws {

        guard !owner.isEmpty, owner != user else {
            throw PDFError.encryptionInvalidPassword
        }

        let status: HPDF_STATUS

        // Workaround for https://bugs.swift.org/browse/SR-2814
        if let user = user {
            status = HPDF_SetPassword(_documentHandle, owner, user)
        } else {
            status = HPDF_SetPassword(_documentHandle, owner, nil)
        }

        if status != UInt(HPDF_OK) {

            HPDF_ResetError(_documentHandle)
            throw _error
        }

        try permissions.map(_setPermissions)
        try encryptionMode.map(_setEncryptionMode)
    }

    // MARK: - Document Info

    private lazy var _dateFormatter = PDFDateFormatter()

    private func _setAttribute(_ attr: HPDF_InfoType, to value: String?) {

        // Workaround for https://bugs.swift.org/browse/SR-2814
        if let value = value {
            HPDF_SetInfoAttr(_documentHandle, attr, value)
        } else {
            HPDF_SetInfoAttr(_documentHandle, attr, nil)
        }
    }
    
    private func _renderMetadata() {
        
        _setAttribute(HPDF_INFO_AUTHOR, to: metadata.author)
        
        _setAttribute(HPDF_INFO_CREATOR, to: metadata.creator)
        
        _setAttribute(HPDF_INFO_TITLE, to: metadata.title)
        
        _setAttribute(HPDF_INFO_SUBJECT, to: metadata.subject)
        
        _setAttribute(HPDF_INFO_KEYWORDS, to: metadata.keywords?.joined(separator: ", "))
        
        let creationDateString = metadata.creationDate.flatMap {
            _dateFormatter.string(from: $0, timeZone: metadata.timeZone)
        }
        
        _setAttribute(HPDF_INFO_CREATION_DATE, to: creationDateString)
        
        let modificationDateString = metadata.modificationDate.flatMap {
            _dateFormatter.string(from: $0, timeZone: metadata.timeZone)
        }
        
        _setAttribute(HPDF_INFO_MOD_DATE, to: modificationDateString)
    }
    
    /// The metadata of the document: an author, keywords, creation date etc.
    public var metadata: Metadata = Metadata()
}
