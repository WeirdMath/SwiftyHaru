This file describes the features of LibHaru that has already been wrapped by SwiftyHaru.

#### Table Key

##### Implementation status:
* ***Implemented***: Functionality is fully implemented.
* ***N/A***: This is not planned to be implemented.
* ***For internal use only***: Some functions that in C are used for memory management or cleanup routine, in SwiftHaru are used internally and called automatically, hence no need to expose them.
* *Unimplemented*: This feature is planned to be implemented, but currently has no implementation.
* *TBD*: The status of these features is not defined yet. It is, obviously, unimplemeted, but whether the implementation is planned or not is to be determined.

## Document Handling

* **[Basic Functions](https://github.com/libharu/libharu/wiki/API%3A-Document#Basic_Functions)**:

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_New()` | **Implemented** | **Complete** | `PDFDocument.init()` |
    | `HPDF_Free()` | **For internal use only** | N/A | N/A |
    | `HPDF_NewDoc()` | **N/A** | N/A | N/A |
    | `HPDF_FreeDoc()` | **N/A** | N/A | N/A |
    | `HPDF_SaveToFile()` | **N/A** | N/A | `document.getData().write(to: url)` |
    | `HPDF_SaveToStream()` | **For internal use only** | N/A | N/A |
    | `HPDF_GetStreamSize()` | **For internal use only** | N/A | N/A |
    | `HPDF_ReadFromStream()` | **Implemented** | **Complete** | `PDFDocument`'s `getData()` instance method |
    | `HPDF_ResetStream()` | **For internal use only** | N/A | N/A |
    | `HPDF_HasDoc()` | **N/A** | N/A | N/A |  |
    | `HPDF_SetErrorHandler()` | **N/A** | N/A | N/A |  |
    | `HPDF_GetError()` | **For internal use only** | N/A | N/A |  |
    | `HPDF_ResetError()` | **For internal use only** | N/A | N/A |  |

* **[Pages Handling](https://github.com/libharu/libharu/wiki/API%3A-Document#Pages_Handling)**

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_SetPagesConfiguration()` | Unimplemented | None | N/A |
    | `HPDF_SetPageLayout()` | **Implemented** | **Complete** | `PDFDocument`'s `pageLayout` instance property |
    | `HPDF_GetPageLayout()` | **Implemented** | **Complete** | `PDFDocument`'s `pageLayout` instance property |
    | `HPDF_SetPageMode()` | Unimplemented | None | N/A |
    | `HPDF_GetPageMode()` | Unimplemented | None | N/A |
    | `HPDF_SetOpenAction()` | Unimplemented | None | N/A |
    | `HPDF_GetCurrentPage()` | **N/A** | N/A | N/A |
    | `HPDF_AddPage()` | **Implemented** | **Complete** | `PDFDocument`'s `addPage()`, `addPage(width:height:)`, `addPage(size:direction:)` instance methods |
    | `HPDF_InsertPage()` | **Implemented** | **Complete** | `PDFDocument`'s  `insertPage(atIndex:)`, `insertPage(width:height:atIndex:)`, `insertPage(size:direction:atIndex:)` instance methods |
    
* **[Font Handling](https://github.com/libharu/libharu/wiki/API%3A-Document#Font_Handling)**

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_AddPageLabel()` | **Implemented** | **Complete** | `PDFDocument`'s `addPageLabel(_:fromPage:startingWith:withPrefix)` instance method |
    | `HPDF_GetFont()` | Unimplemented | None | N/A |
    | `HPDF_LoadType1FontFromFile()` | TBD | N/A | N/A |
    | `HPDF_LoadTTFontFromFile()` | TBD | N/A | N/A |
    | `HPDF_LoadTTFontFromFile2()` | TBD | N/A | N/A |
    | `HPDF_UseJPFonts()` | Unimplemented | None | N/A |
    | `HPDF_UseKRFonts()` | Unimplemented | None | N/A |
    | `HPDF_UseCNSFonts()` | Unimplemented | None | N/A |
    | `HPDF_UseCNTFonts()` | Unimplemented | None | N/A |

* **[Encodings](https://github.com/libharu/libharu/wiki/API%3A-Document#Encodings)**
    
    Unimplemented

* **[Other Functions](https://github.com/libharu/libharu/wiki/API%3A-Document#Other_Functions)**
    
    Unimplemented

## Page Handling

| Function  | Status | Test Coverage | SwiftyHaru equivalent |
|-----------|--------|---------------|-----------------------|
| `HPDF_Page_SetWidth()` | **Implemented** | **Complete** | `PDFPage`'s `width` instance property |
| `HPDF_Page_SetHeight()` | **Implemented** | **Complete** | `PDFPage`'s `height` instance property |
| `HPDF_Page_SetSize()` | **Implemented** | **Complete** | `PDFPage`'s `set(size:direction:)` instance method |
| `HPDF_Page_SetRotate()` | **Implemented** | **Complete** | `PDFPage`'s `rotate(byAngle:)` instance method |
| `HPDF_Page_GetWidth()` | **Implemented** | **Complete** | `PDFPage`'s `width` instance property |
| `HPDF_Page_GetHeight()` | **Implemented** | **Complete** | `PDFPage`'s `height` instance property |
| `HPDF_Page_CreateDestination()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateTextAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateLinkAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateURILinkAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_TextWidth()` | Unimplemented | None | N/A |
| `HPDF_Page_MeasureText()` | Unimplemented | None | N/A |
| `HPDF_Page_GetGMode()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCurrentPos()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCurrentTextPos()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCurrentFont()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCurrentFontSize()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTransMatrix()` | Unimplemented | None | N/A |
| `HPDF_Page_GetLineWidth()` | Unimplemented | None | N/A |
| `HPDF_Page_GetLineCap()` | Unimplemented | None | N/A |
| `HPDF_Page_GetLineJoin()` | Unimplemented | None | N/A |
| `HPDF_Page_GetMiterLimit()` | Unimplemented | None | N/A |
| `HPDF_Page_GetDash()` | Unimplemented | None | N/A |
| `HPDF_Page_GetFlat()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCharSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_GetWordSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_GetHorizontalScalling()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextLeading()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextRenderingMode()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextRise()` | Unimplemented | None | N/A |
| `HPDF_Page_GetRGBFill()` | Unimplemented | None | N/A |
| `HPDF_Page_GetRGBStroke()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCMYKFill()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCMYKStroke()` | Unimplemented | None | N/A |
| `HPDF_Page_GetGrayFill()` | Unimplemented | None | N/A |
| `HPDF_Page_GetGrayStroke()` | Unimplemented | None | N/A |
| `HPDF_Page_GetStrokingColorSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_GetFillingColorSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextMatrix()` | Unimplemented | None | N/A |
| `HPDF_Page_GetGStateDepth()` | TBD | None | N/A |
| `HPDF_Page_SetSlideShow()` | Unimplemented | None | N/A |
| `HPDF_Page_New_Content_Stream()` | TBD | None | N/A |
| `HPDF_Page_Insert_Shared_Content_Stream()` | TBD | None | N/A |

## Graphics

Unimplemented

## Font Handling

Unimplemented

## Encoding

Unimplemented

## Annotation

Unimplemented

## Outline

Unimplemented

## Destination

Unimplemented

## Image

Unimplemented
