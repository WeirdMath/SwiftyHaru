//
//  PDFDocument.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 30.09.16.
//
//

import Foundation
import DefaultStringConvertible
import CLibHaru

/// A handle to operate on a document object.
public final class PDFDocument {
    
    internal var _documentHandle: HPDF_Doc
    
    public private(set) var pages: [PDFPage] = []
    
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
    
    /// Creates a new page and adds it after the last page of the document.
    ///
    /// - returns: A `PDFPage` object.
    @discardableResult public func addPage() -> PDFPage {
        
        let haruPage = HPDF_AddPage(_documentHandle)!
        
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
        
        let haruTargetPage = pages[index]._pageHandle
        
        let haruInsertedPage = HPDF_InsertPage(_documentHandle, haruTargetPage)!
        
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
        
        HPDF_SaveToStream(_documentHandle)
        
        let sizeOfStream = HPDF_GetStreamSize(_documentHandle)
        
        HPDF_ResetStream(_documentHandle)
        
        let buffer = UnsafeMutablePointer<HPDF_BYTE>.allocate(capacity: Int(sizeOfStream))
        var sizeOfBuffer = sizeOfStream
        
        HPDF_ReadFromStream(_documentHandle, buffer, &sizeOfBuffer)
        
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
                             withPrefix prefix: String? = nil) {
        
        let prefix = prefix?.cString(using: .ascii)
        
        HPDF_AddPageLabel(_documentHandle,
                          HPDF_UINT(startingPage),
                          HPDF_PageNumStyle(rawValue: style.rawValue),
                          HPDF_UINT(firstPageNumber),
                          prefix)
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
            
            let cString = HPDF_LoadTTFontFromMemory2(self._documentHandle,
                                                     pointer,
                                                     HPDF_UINT(data.count),
                                                     HPDF_UINT(index),
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
    public func setEncryptionMode(to mode: EncryptionMode) throws {

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

    /// Sets the permission flags for the document.
    ///
    /// - Important: Prior to calling this method you must set the password using
    ///              the `setPassword(owner:user:)` method.
    ///
    /// - Parameter permissions: The permission flags for the document.
    /// - Throws: `PDFError.documentEncryptionDictionaryNotFound` if you haven't set a password.
    public func setPermissions(to permissions: Permissions) throws {

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
    ///   - user:  The password for the user of the document. May be set to `nil` or zero length string.
    /// - Throws:  `PDFError.encryptionInvalidPassword` if the owner password is zero length string or
    ///            same value as the user password.
    public func setPassword(owner: String, user: String? = nil) throws {

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
    }

    // MARK: - Document Info

    private lazy var _dateFormatter = PDFDateFormatter()

    private func _getAttribute(_ attr: HPDF_InfoType) -> String? {
        let pointer = HPDF_GetInfoAttr(_documentHandle, attr)
        return pointer.map(String.init(cString:))
    }

    private func _setAttribute(_ attr: HPDF_InfoType, to value: String?) {

        // Workaround for https://bugs.swift.org/browse/SR-2814
        if let value = value {
            HPDF_SetInfoAttr(_documentHandle, attr, value)
        } else {
            HPDF_SetInfoAttr(_documentHandle, attr, nil)
        }
    }

    /// The author of the document.
    public var author: String? {
        get {
            return _getAttribute(HPDF_INFO_AUTHOR)
        }
        set {
            _setAttribute(HPDF_INFO_AUTHOR, to: newValue)
        }
    }

    /// The creator of the document.
    public var creator: String? {
        get {
            return _getAttribute(HPDF_INFO_CREATOR)
        }
        set {
            _setAttribute(HPDF_INFO_CREATOR, to: newValue)
        }
    }

    /// The title of the document.
    public var title: String? {
        get {
            return _getAttribute(HPDF_INFO_TITLE)
        }
        set {
            _setAttribute(HPDF_INFO_TITLE, to: newValue)
        }
    }

    /// The subject of the document.
    public var subject: String? {
        get {
            return _getAttribute(HPDF_INFO_SUBJECT)
        }
        set {
            _setAttribute(HPDF_INFO_SUBJECT, to: newValue)
        }
    }

    /// The keywords of the document.
    public var keywords: [String]? {
        get {
            
            return _getAttribute(HPDF_INFO_KEYWORDS)
                .map { keywordsString in
                
                    keywordsString.isEmpty ? [] : keywordsString.components(separatedBy: ", ")
                    
                }?.map { keyword in
                    keyword.trimmingCharacters(in: .whitespacesAndNewlines)
                }
        }
        set {
            _setAttribute(HPDF_INFO_KEYWORDS, to: newValue?.joined(separator: ", "))
        }
    }

    /// The timezone to use for encoding the creation date and the modification date of the document.
    /// Default value is `TimeZone.current`
    public var timeZone: TimeZone = .current {
        didSet {
            // Update the values with the new time zone
            let _creationDate = creationDate
            creationDate = _creationDate
            
            let _modificationDate = modificationDate
            modificationDate = _modificationDate
        }
    }

    /// The document’s creation date.
    public var creationDate: Date? {
        get {
            let dateString = _getAttribute(HPDF_INFO_CREATION_DATE)
            return dateString.flatMap(_dateFormatter.date(from:))
        }
        set {
            let dateString = newValue.flatMap { _dateFormatter.string(from: $0, timeZone: timeZone) }
            _setAttribute(HPDF_INFO_CREATION_DATE, to: dateString)
        }
    }

    /// The document’s last-modified date.
    public var modificationDate: Date? {
        get {
            let dateString = _getAttribute(HPDF_INFO_MOD_DATE)
            return dateString.flatMap(_dateFormatter.date(from:))
        }
        set {
            let dateString = newValue.flatMap { _dateFormatter.string(from: $0, timeZone: timeZone) }
            _setAttribute(HPDF_INFO_MOD_DATE, to: dateString)
        }
    }
}

extension PDFDocument: CustomStringConvertible {}
