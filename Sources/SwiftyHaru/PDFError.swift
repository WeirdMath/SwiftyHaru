//
//  PDFError.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 30.09.16.
//
//

#if SWIFT_PACKAGE
import CLibHaru
#endif

public struct PDFError: Error {
    
    public var code: Int32
    
    internal init(code: Int32) {
        self.code = code
    }
    
    /// Internal error. Data consistency was lost.
    public static let arrayCountError = PDFError(code: HPDF_ARRAY_COUNT_ERR)
    
    /// Internal error. Data consistency was lost.
    public static let arrayItemNotFound = PDFError(code: HPDF_ARRAY_ITEM_NOT_FOUND)
    
    /// Internal error. Data consistency was lost.
    public static let arrayItemUnexpectedType = PDFError(code: HPDF_ARRAY_ITEM_UNEXPECTED_TYPE)
    
    /// Data length > HPDF_LIMIT_MAX_STRING_LEN.
    public static let binaryLengthError = PDFError(code: HPDF_BINARY_LENGTH_ERR)
    
    /// Cannot get pallet data from PNG image.
    public static let cannotGetPallet = PDFError(code: HPDF_CANNOT_GET_PALLET)
    
    /// Dictionary elements > HPDF_LIMIT_MAX_DICT_ELEMENT
    public static let dictionaryCountError = PDFError(code: HPDF_DICT_COUNT_ERR)
    
    /// Internal error. Data consistency was lost.
    public static let dictionaryItemNotFound = PDFError(code: HPDF_DICT_ITEM_NOT_FOUND)
    
    /// Internal error. Data consistency was lost.
    public static let dictionaryItemUnexpectedType = PDFError(code: HPDF_DICT_ITEM_UNEXPECTED_TYPE)
    
    /// Internal error. Data consistency was lost.
    public static let dictionaryStreamLengthNotFound = PDFError(code: HPDF_DICT_STREAM_LENGTH_NOT_FOUND)
    
    /// `PDFDocument.setEncryptionMode(to:)` or `PDFDocument.setPermissions(to:)` called
    /// before password set.
    public static let documentEncryptionDictionaryNotFound = PDFError(code: HPDF_DOC_ENCRYPTDICT_NOT_FOUND)
    
    /// Internal error. Data consistency was lost.
    public static let documentInvalidObject = PDFError(code: HPDF_DOC_INVALID_OBJECT)
    
    /// Tried to re-register a registered font.
    public static let duplicateRegistration = PDFError(code: HPDF_DUPLICATE_REGISTRATION)
    
    /// Cannot register a character to the Japanese word wrap characters list.
    public static let exceedJWWCodeNumberLimit = PDFError(code: HPDF_EXCEED_JWW_CODE_NUM_LIMIT)
    
    /// 1. Tried to set the owner password to NULL.
    /// 2. Owner and user password are the same.
    public static let encryptionInvalidPassword = PDFError(code: HPDF_ENCRYPT_INVALID_PASSWORD)
    
    /// Internal error. Data consistency was lost.
    public static let unknownClass = PDFError(code: HPDF_ERR_UNKNOWN_CLASS)
    
    /// Stack depth > HPDF_LIMIT_MAX_GSTATE.
    public static let exceedGStateLimit = PDFError(code: HPDF_EXCEED_GSTATE_LIMIT)
    
    /// Memory allocation failed.
    public static let failedToAllocateMemory = PDFError(code: HPDF_FAILD_TO_ALLOC_MEM)
    
    /// File processing failed. (Detailed code is set.)
    public static let fileIOError = PDFError(code: HPDF_FILE_IO_ERROR)
    
    /// Cannot open a file. (Detailed code is set.)
    public static let fileOpenError = PDFError(code: HPDF_FILE_OPEN_ERROR)
    
    /// Tried to load a font that has been registered.
    public static let fontExists = PDFError(code: HPDF_FONT_EXISTS)
    
    /// 1. Font-file format is invalid.
    /// 2. Internal error. Data consistency was lost.
    public static let fontInvalidWidthsTable = PDFError(code: HPDF_FONT_INVALID_WIDTHS_TABLE)
    
    /// Cannot recognize header of afm file.
    public static let invalidAFMHeader = PDFError(code: HPDF_INVALID_AFM_HEADER)
    
    /// Specified annotation handle is invalid.
    public static let invalidAnnotation = PDFError(code: HPDF_INVALID_ANNOTATION)
    
    /// Bit-per-component of a image which was set as mask-image is invalid.
    public static let invalidBitPerComponent = PDFError(code: HPDF_INVALID_BIT_PER_COMPONENT)
    
    /// Cannot recognize char-matrics-data of afm file.
    public static let invalidCharMatricsData = PDFError(code: HPDF_INVALID_CHAR_MATRICS_DATA)
    
    /// 1. Invalid color_space parameter of HPDF_LoadRawImage.
    /// 2. Color-space of a image which was set as mask-image is invalid.
    /// 3. Invoked function invalid in present color-space.
    public static let invalidColorSpace = PDFError(code: HPDF_INVALID_COLOR_SPACE)
    
    /// Invalid value set when invoking HPDF_SetCommpressionMode().
    public static let invalidCompressionMode = PDFError(code: HPDF_INVALID_COMPRESSION_MODE)
    
    /// An invalid date-time value was set.
    public static let invalidDateTime = PDFError(code: HPDF_INVALID_DATE_TIME)
    
    /// An invalid destination handle was set.
    public static let invalidDestination = PDFError(code: HPDF_INVALID_DESTINATION)
    
    /// An invalid document handle was set.
    public static let invalidDocument = PDFError(code: HPDF_INVALID_DOCUMENT)
    
    /// Function invalid in the present state was invoked.
    public static let invalidDocumentState = PDFError(code: HPDF_INVALID_DOCUMENT_STATE)
    
    /// An invalid encoder handle was set.
    public static let invalidEncoder = PDFError(code: HPDF_INVALID_ENCODER)
    
    /// Combination between font and encoder is wrong.
    public static let invalidEncoderType = PDFError(code: HPDF_INVALID_ENCODER_TYPE)
    
    /// An Invalid encoding name is specified.
    public static let invalidEncodingName = PDFError(code: HPDF_INVALID_ENCODING_NAME)
    
    /// Encryption key length is invalid.
    public static let invalidEncryptionKeyLength = PDFError(code: HPDF_INVALID_ENCRYPT_KEY_LEN)
    
    /// 1. An invalid font handle was set.
    /// 2. Unsupported font format.
    public static let invalidFontdefData = PDFError(code: HPDF_INVALID_FONTDEF_DATA)
    
    /// Internal error. Data consistency was lost.
    public static let invalidFontdefType = PDFError(code: HPDF_INVALID_FONTDEF_TYPE)
    
    /// Font with the specified name is not found.
    public static let invalidFontName = PDFError(code: HPDF_INVALID_FONT_NAME)
    
    /// Unsupported image format.
    public static let invalidImage = PDFError(code: HPDF_INVALID_IMAGE)
    
    /// Unsupported image format.
    public static let invalidJPEGData = PDFError(code: HPDF_INVALID_JPEG_DATA)
    
    /// Cannot read a postscript-name from an afm file.
    public static let invalidNData = PDFError(code: HPDF_INVALID_N_DATA)
    
    /// 1. An invalid object is set.
    /// 2. Internal error. Data consistency was lost.
    public static let invalidObject = PDFError(code: HPDF_INVALID_OBJECT)
    
    /// Internal error. Data consistency was lost.
    public static let invalidObjectID = PDFError(code: HPDF_INVALID_OBJ_ID)
    
    /// Invoked HPDF_Image_SetColorMask() against the image-object which was set a mask-image.
    public static let invalidOperation = PDFError(code: HPDF_INVALID_OPERATION)
    
    /// An invalid outline-handle was specified.
    public static let invalidOutline = PDFError(code: HPDF_INVALID_OUTLINE)
    
    /// An invalid page-handle was specified.
    public static let invalidPage = PDFError(code: HPDF_INVALID_PAGE)
    
    /// An invalid pages-handle was specified. (internal error)
    public static let invalidPages = PDFError(code: HPDF_INVALID_PAGES)
    
    /// An invalid value is set.
    public static let invalidParameter = PDFError(code: HPDF_INVALID_PARAMETER)
    
    /// Invalid PNG image format.
    public static let invalidPNGImage = PDFError(code: HPDF_INVALID_PNG_IMAGE)
    
    /// Internal error. Data consistency was lost.
    public static let invalidStream = PDFError(code: HPDF_INVALID_STREAM)
    
    /// Internal error. "_FILE_NAME" entry for delayed loading is missing.
    public static let missingFileNameEntry = PDFError(code: HPDF_MISSING_FILE_NAME_ENTRY)
    
    /// Invalid .TTC file format.
    public static let invalidTTCFile = PDFError(code: HPDF_INVALID_TTC_FILE)
    
    /// Index parameter > number of included fonts.
    public static let invalidTTCIndex = PDFError(code: HPDF_INVALID_TTC_INDEX)
    
    /// Cannot read a width-data from an afm file.
    public static let invalidWXData = PDFError(code: HPDF_INVALID_WX_DATA)
    
    /// Internal error. Data consistency was lost.
    public static let itemNotFound = PDFError(code: HPDF_ITEM_NOT_FOUND)
    
    /// Error returned from PNGLIB while loading image.
    public static let libpngError = PDFError(code: HPDF_LIBPNG_ERROR)
    
    /// Internal error. Data consistency was lost.
    public static let nameInvalidValue = PDFError(code: HPDF_NAME_INVALID_VALUE)
    
    /// Internal error. Data consistency was lost.
    public static let nameOutOfRange = PDFError(code: HPDF_NAME_OUT_OF_RANGE)
    
    public static let pageInvalidParametersCount = PDFError(code: HPDF_PAGE_INVALID_PARAM_COUNT)
    
    /// Internal error. Data consistency was lost.
    public static let pagesMissingKidsEntry = PDFError(code: HPDF_PAGES_MISSING_KIDS_ENTRY)
    
    /// Internal error. Data consistency was lost.
    public static let pageCannotFindObject = PDFError(code: HPDF_PAGE_CANNOT_FIND_OBJECT)
    
    /// Internal error. Data consistency was lost.
    public static let cannotGetRootPages = PDFError(code: HPDF_PAGE_CANNOT_GET_ROOT_PAGES)
    
    /// There are no graphics-states to be restored.
    public static let pageCannotRestoreGState = PDFError(code: HPDF_PAGE_CANNOT_RESTORE_GSTATE)
    
    /// Internal error. Data consistency was lost.
    public static let pageCannotSetParent = PDFError(code: HPDF_PAGE_CANNOT_SET_PARENT)
    
    /// The current font is not set.
    public static let pageFontNotFound = PDFError(code: HPDF_PAGE_FONT_NOT_FOUND)
    
    /// An invalid font-handle was specified.
    public static let pageInvalidFont = PDFError(code: HPDF_PAGE_INVALID_FONT)
    
    /// An invalid font-size was set.
    public static let pageInvalidFontSize = PDFError(code: HPDF_PAGE_INVALID_FONT_SIZE)
    
    public static let pageInvalidGMode = PDFError(code: HPDF_PAGE_INVALID_GMODE)
    
    /// Internal error. Data consistency was lost.
    public static let pageInvalidIndex = PDFError(code: HPDF_PAGE_INVALID_INDEX)
    
    /// Specified value is not multiple of 90.
    public static let pageInvalidRotateValue = PDFError(code: HPDF_PAGE_INVALID_ROTATE_VALUE)
    
    /// An invalid page-size was set.
    public static let pageInvalidSize = PDFError(code: HPDF_PAGE_INVALID_SIZE)
    
    /// An invalid image-handle was set.
    public static let pageInvalidXObject = PDFError(code: HPDF_PAGE_INVALID_XOBJECT)
    
    /// The specified value is out of range.
    public static let pageOutOfRange = PDFError(code: HPDF_PAGE_OUT_OF_RANGE)
    
    /// The specified value is out of range.
    public static let realOutOfRange = PDFError(code: HPDF_REAL_OUT_OF_RANGE)
    
    /// Unexpected EOF marker was detected.
    public static let streamEOF = PDFError(code: HPDF_STREAM_EOF)
    
    /// Internal error. Data consistency was lost.
    public static let streamReadlnContinue = PDFError(code: HPDF_STREAM_READLN_CONTINUE)
    
    /// The length of the text is too long.
    public static let stringOutOfRange = PDFError(code: HPDF_STRING_OUT_OF_RANGE)
    
    /// Function not executed because of other errors.
    public static let thisFunctionWasSkipped = PDFError(code: HPDF_THIS_FUNC_WAS_SKIPPED)
    
    /// Font cannot be embedded. (license restriction)
    public static let ttfCannotEmbedFont = PDFError(code: HPDF_TTF_CANNOT_EMBEDDING_FONT)
    
    /// Unsupported ttf format. (cannot find unicode cmap)
    public static let ttfInvalidCMap = PDFError(code: HPDF_TTF_INVALID_CMAP)
    
    /// Unsupported ttf format.
    public static let ttfInvalidFormat = PDFError(code: HPDF_TTF_INVALID_FOMAT)
    
    /// Unsupported ttf format. (cannot find a necessary table)
    public static let ttfMissingTable = PDFError(code: HPDF_TTF_MISSING_TABLE)
    
    /// Internal error. Data consistency was lost.
    public static let unsupportedFontType = PDFError(code: HPDF_UNSUPPORTED_FONT_TYPE)
    
    /// 1. Library not configured to use PNGLIB.
    /// 2. Internal error. Data consistency was lost.
    public static let unsupportedFunction = PDFError(code: HPDF_UNSUPPORTED_FUNC)
    
    /// Unsupported JPEG format.
    public static let usupportedJPEGFormat = PDFError(code: HPDF_UNSUPPORTED_JPEG_FORMAT)
    
    /// Failed to parse .PFB file.
    public static let unsupportedType1Font = PDFError(code: HPDF_UNSUPPORTED_TYPE1_FONT)
    
    /// Internal error. Data consistency was lost.
    public static let xrefCountError = PDFError(code: HPDF_XREF_COUNT_ERR)
    
    /// Error while executing ZLIB function.
    public static let zlibError = PDFError(code: HPDF_ZLIB_ERROR)
    
    /// An invalid page index was passed.
    public static let invalidPageIndex = PDFError(code: HPDF_INVALID_PAGE_INDEX)
    
    /// An invalid URI was set.
    public static let invalidURI = PDFError(code: HPDF_INVALID_URI)
    
    /// An invalid page-layout was set.
    public static let pageLayoutOutOfRange = PDFError(code: HPDF_PAGE_LAYOUT_OUT_OF_RANGE)
    
    /// An invalid page-mode was set.
    public static let pageModeOutOfRange = PDFError(code: HPDF_PAGE_MODE_OUT_OF_RANGE)
    
    /// An invalid page-num-style was set.
    public static let pageNumberStyleOutOfRange = PDFError(code: HPDF_PAGE_NUM_STYLE_OUT_OF_RANGE)
    
    /// An invalid icon was set.
    public static let annotationInvalidIcon = PDFError(code: HPDF_ANNOT_INVALID_ICON)
    
    /// An invalid border-style was set.
    public static let annotationInvalidBorderStyle = PDFError(code: HPDF_ANNOT_INVALID_BORDER_STYLE)
    
    /// An invalid page-direction was set.
    public static let pageInvalidDirection = PDFError(code: HPDF_PAGE_INVALID_DIRECTION)
    
    /// An invalid font-handle was specified.
    public static let invalidFont = PDFError(code: HPDF_INVALID_FONT)
    
    public static let pageInsufficientSpace = PDFError(code: HPDF_PAGE_INSUFFICIENT_SPACE)
    
    public static let pageInvalidDisplayTime = PDFError(code: HPDF_PAGE_INVALID_DISPLAY_TIME)
    
    public static let pageInvalidTransitionTime = PDFError(code: HPDF_PAGE_INVALID_TRANSITION_TIME)
    
    public static let invalidPageSlideshowType = PDFError(code: HPDF_INVALID_PAGE_SLIDESHOW_TYPE)
    
    public static let extGStateOutOfRange = PDFError(code: HPDF_EXT_GSTATE_OUT_OF_RANGE)
    
    public static let invalidExtGState = PDFError(code: HPDF_INVALID_EXT_GSTATE)
    
    public static let extGStateReadOnly = PDFError(code: HPDF_EXT_GSTATE_READ_ONLY)
    
    public static let invalidU3DData = PDFError(code: HPDF_INVALID_U3D_DATA)
    
    public static let nameCannotGetNames = PDFError(code: HPDF_NAME_CANNOT_GET_NAMES)
    
    public static let invalidICCComponentNumber = PDFError(code: HPDF_INVALID_ICC_COMPONENT_NUM)
    
    private static var _descriptions = [
        HPDF_ARRAY_COUNT_ERR : "Internal error. Data consistency was lost.",
        HPDF_ARRAY_ITEM_NOT_FOUND : "Internal error. Data consistency was lost.",
        HPDF_ARRAY_ITEM_UNEXPECTED_TYPE : "Internal error. Data consistency was lost.",
        HPDF_BINARY_LENGTH_ERR : "Data length > HPDF_LIMIT_MAX_STRING_LEN.",
        HPDF_CANNOT_GET_PALLET : "Cannot get pallet data from PNG image.",
        HPDF_DICT_COUNT_ERR : "Dictionary elements > HPDF_LIMIT_MAX_DICT_ELEMENT",
        HPDF_DICT_ITEM_NOT_FOUND : "Internal error. Data consistency was lost.",
        HPDF_DICT_ITEM_UNEXPECTED_TYPE : "Internal error. Data consistency was lost.",
        HPDF_DICT_STREAM_LENGTH_NOT_FOUND : "Internal error. Data consistency was lost.",
        HPDF_DOC_ENCRYPTDICT_NOT_FOUND : "HPDF_SetEncryptMode() or HPDF_SetPermission() called" +
        " before password set.",
        HPDF_DOC_INVALID_OBJECT : "Internal error. Data consistency was lost.",
        HPDF_DUPLICATE_REGISTRATION : "Tried to re-register a registered font.",
        HPDF_EXCEED_JWW_CODE_NUM_LIMIT : "Cannot register a character to the Japanese word wrap" +
        " characters list.",
        HPDF_ENCRYPT_INVALID_PASSWORD : "1. Tried to set the owner password to NULL. " +
        "2. Owner and user password are the same.",
        HPDF_ERR_UNKNOWN_CLASS : "Internal error. Data consistency was lost.",
        HPDF_EXCEED_GSTATE_LIMIT : "Stack depth > HPDF_LIMIT_MAX_GSTATE.",
        HPDF_FAILD_TO_ALLOC_MEM : "Memory allocation failed.",
        HPDF_FILE_IO_ERROR : "File processing failed.",
        HPDF_FILE_OPEN_ERROR : "Cannot open a file.",
        HPDF_FONT_EXISTS : "Tried to load a font that has been registered.",
        HPDF_FONT_INVALID_WIDTHS_TABLE : "1. Font-file format is invalid. " +
        "2. Internal error. Data consistency was lost.",
        HPDF_INVALID_AFM_HEADER : "Cannot recognize header of afm file.",
        HPDF_INVALID_ANNOTATION : "Specified annotation handle is invalid.",
        HPDF_INVALID_BIT_PER_COMPONENT : "Bit-per-component of an image which was set as " +
        "mask-image is invalid.",
        HPDF_INVALID_CHAR_MATRICS_DATA : "Cannot recognize char-matrics-data of afm file.",
        HPDF_INVALID_COLOR_SPACE : "1. Invalid color_space parameter of HPDF_LoadRawImage. " +
            "2. Color-space of a image which was set as mask-image is invalid. " +
        "3. Invoked function invalid in present color-space.",
        HPDF_INVALID_COMPRESSION_MODE : "Invalid value set when invoking HPDF_SetCommpressionMode().",
        HPDF_INVALID_DATE_TIME : "An invalid date-time value was set.",
        HPDF_INVALID_DESTINATION : "An invalid destination handle was set.",
        HPDF_INVALID_DOCUMENT : "An invalid document handle was set.",
        HPDF_INVALID_DOCUMENT_STATE : "Function invalid in the present state was invoked.",
        HPDF_INVALID_ENCODER : "An invalid encoder handle was set.",
        HPDF_INVALID_ENCODER_TYPE : "Combination between font and encoder is wrong.",
        HPDF_INVALID_ENCODING_NAME : "An Invalid encoding name is specified.",
        HPDF_INVALID_ENCRYPT_KEY_LEN : "Encryption key length is invalid.",
        HPDF_INVALID_FONTDEF_DATA : "1. An invalid font handle was set. 2. Unsupported font format.",
        HPDF_INVALID_FONTDEF_TYPE : "Internal error. Data consistency was lost.",
        HPDF_INVALID_FONT_NAME : "Font with the specified name is not found.",
        HPDF_INVALID_IMAGE : "Unsupported image format.",
        HPDF_INVALID_JPEG_DATA : "Unsupported image format.",
        HPDF_INVALID_N_DATA : "Cannot read a postscript-name from an afm file.",
        HPDF_INVALID_OBJECT : "1. An invalid object is set. 2. Internal error. Data consistency was lost.",
        HPDF_INVALID_OBJ_ID : "Internal error. Data consistency was lost.",
        HPDF_INVALID_OPERATION : "Invoked HPDF_Image_SetColorMask() against the image-object which was" +
        " set a mask-image.",
        HPDF_INVALID_OUTLINE : "An invalid outline-handle was specified.",
        HPDF_INVALID_PAGE : "An invalid page-handle was specified.",
        HPDF_INVALID_PAGES : "An invalid pages-handle was specified. (internal error)",
        HPDF_INVALID_PARAMETER : "An invalid value is set.",
        HPDF_INVALID_PNG_IMAGE : "Invalid PNG image format.",
        HPDF_INVALID_STREAM : "Internal error. Data consistency was lost.",
        HPDF_MISSING_FILE_NAME_ENTRY : "Internal error. \"_FILE_NAME\" entry for delayed loading is missing.",
        HPDF_INVALID_TTC_FILE : "Invalid .TTC file format.",
        HPDF_INVALID_TTC_INDEX : "Index parameter > number of included fonts.",
        HPDF_INVALID_WX_DATA : "Cannot read a width-data from an afm file.",
        HPDF_ITEM_NOT_FOUND : "Internal error. Data consistency was lost.",
        HPDF_LIBPNG_ERROR : "Error returned from PNGLIB while loading image.",
        HPDF_NAME_INVALID_VALUE : "Internal error. Data consistency was lost.",
        HPDF_NAME_OUT_OF_RANGE : "Internal error. Data consistency was lost.",
        HPDF_PAGES_MISSING_KIDS_ENTRY : "Internal error. Data consistency was lost.",
        HPDF_PAGE_CANNOT_FIND_OBJECT : "Internal error. Data consistency was lost.",
        HPDF_PAGE_CANNOT_GET_ROOT_PAGES : "Internal error. Data consistency was lost.",
        HPDF_PAGE_CANNOT_RESTORE_GSTATE : "There are no graphics-states to be restored.",
        HPDF_PAGE_CANNOT_SET_PARENT : "Internal error. Data consistency was lost.",
        HPDF_PAGE_FONT_NOT_FOUND : "The current font is not set.",
        HPDF_PAGE_INVALID_FONT : "An invalid font-handle was specified.",
        HPDF_PAGE_INVALID_FONT_SIZE : "An invalid font-size was set.",
        HPDF_PAGE_INVALID_INDEX : "Internal error. Data consistency was lost.",
        HPDF_PAGE_INVALID_ROTATE_VALUE : "Specified value is not multiple of 90.",
        HPDF_PAGE_INVALID_SIZE : "An invalid page-size was set.",
        HPDF_PAGE_INVALID_XOBJECT : "An invalid image-handle was set.",
        HPDF_PAGE_OUT_OF_RANGE : "The specified value is out of range.",
        HPDF_REAL_OUT_OF_RANGE : "The specified value is out of range.",
        HPDF_STREAM_EOF : "Unexpected EOF marker was detected.",
        HPDF_STREAM_READLN_CONTINUE : "Internal error. Data consistency was lost.",
        HPDF_STRING_OUT_OF_RANGE : "The length of the text is too long.",
        HPDF_THIS_FUNC_WAS_SKIPPED : "Function not executed because of other errors.",
        HPDF_TTF_CANNOT_EMBEDDING_FONT : "Font cannot be embedded. (license restriction)",
        HPDF_TTF_INVALID_CMAP : "Unsupported ttf format. (cannot find unicode cmap)",
        HPDF_TTF_INVALID_FOMAT : "Unsupported ttf format.",
        HPDF_TTF_MISSING_TABLE : "Unsupported ttf format. (cannot find a necessary table)",
        HPDF_UNSUPPORTED_FONT_TYPE : "Internal error. Data consistency was lost.",
        HPDF_UNSUPPORTED_FUNC : "1. Library not configured to use PNGLIB. " +
        "2. Internal error. Data consistency was lost.",
        HPDF_UNSUPPORTED_JPEG_FORMAT : "Unsupported JPEG format.",
        HPDF_UNSUPPORTED_TYPE1_FONT : "Failed to parse .PFB file.",
        HPDF_XREF_COUNT_ERR : "Internal error. Data consistency was lost.",
        HPDF_ZLIB_ERROR : "Error while executing ZLIB function.",
        HPDF_INVALID_PAGE_INDEX : "An invalid page index was passed.",
        HPDF_INVALID_URI : "An invalid URI was set.",
        HPDF_PAGE_LAYOUT_OUT_OF_RANGE : "An invalid page-layout was set.",
        HPDF_PAGE_MODE_OUT_OF_RANGE : "An invalid page-mode was set.",
        HPDF_PAGE_NUM_STYLE_OUT_OF_RANGE : "An invalid page-num-style was set.",
        HPDF_ANNOT_INVALID_ICON : "An invalid icon was set.",
        HPDF_ANNOT_INVALID_BORDER_STYLE : "An invalid border-style was set.",
        HPDF_PAGE_INVALID_DIRECTION : "An invalid page-direction was set.",
        HPDF_INVALID_FONT : "An invalid font-handle was specified.",
    ]
    
    public var description: String {
        
        if code == 0 {
            return "No error."
        }
        
        return PDFError._descriptions[code] ?? "Unknown error."
    }
}

extension PDFError: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: PDFError, rhs: PDFError) -> Bool {
        return lhs.code == rhs.code
    }
}
