This file describes the features of LibHaru that has already been wrapped by SwiftyHaru.

#### Table Key

**Bold** status means that no changes are planned regarding this feature.

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
    | `HPDF_New()` | **Implemented** | Complete | `PDFDocument.init()` |
    | `HPDF_Free()` | **For internal use only** | N/A | N/A |
    | `HPDF_NewDoc()` | **N/A** | N/A | N/A |
    | `HPDF_FreeDoc()` | **N/A** | N/A | N/A |
    | `HPDF_SaveToFile()` | **N/A** | N/A | `document.getData().write(to: url)` |
    | `HPDF_SaveToStream()` | **For internal use only** | N/A | N/A |
    | `HPDF_GetStreamSize()` | **For internal use only** | N/A | N/A |
    | `HPDF_ReadFromStream()` | **Implemented** | Complete | `PDFDocument`'s `getData()` instance method |
    | `HPDF_ResetStream()` | **For internal use only** | N/A | N/A |
    | `HPDF_HasDoc()` | **N/A** | N/A | N/A |  |
    | `HPDF_SetErrorHandler()` | **N/A** | N/A | N/A |  |
    | `HPDF_GetError()` | **For internal use only** | N/A | N/A |  |
    | `HPDF_ResetError()` | **For internal use only** | N/A | N/A |  |

* **[Pages Handling](https://github.com/libharu/libharu/wiki/API%3A-Document#Pages_Handling)**

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_SetPagesConfiguration()` | Unimplemented | None | N/A |
    | `HPDF_SetPageLayout()` | **Implemented** | Complete | `PDFDocument`'s `pageLayout` instance property |
    | `HPDF_GetPageLayout()` | **Implemented** | Complete | `PDFDocument`'s `pageLayout` instance property |
    | `HPDF_SetPageMode()` | Unimplemented | None | N/A |
    | `HPDF_GetPageMode()` | Unimplemented | None | N/A |
    | `HPDF_SetOpenAction()` | Unimplemented | None | N/A |
    | `HPDF_GetCurrentPage()` | **N/A** | N/A | N/A |
    | `HPDF_AddPage()` | **Implemented** | Complete | `PDFDocument`'s `addPage()`, `addPage(width:height:)`, `addPage(size:direction:)` instance methods |
    | `HPDF_InsertPage()` | **Implemented** | Complete | `PDFDocument`'s  `insertPage(atIndex:)`, `insertPage(width:height:atIndex:)`, `insertPage(size:direction:atIndex:)` instance methods |
    
* **[Font Handling](https://github.com/libharu/libharu/wiki/API%3A-Document#Font_Handling)**

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_AddPageLabel()` | **Implemented** | Complete | `PDFDocument`'s `addPageLabel(_:fromPage:startingWith:withPrefix)` instance method |
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
| `HPDF_Page_SetWidth()` | **Implemented** | Complete | `PDFPage`'s `width` instance property |
| `HPDF_Page_SetHeight()` | **Implemented** | Complete | `PDFPage`'s `height` instance property |
| `HPDF_Page_SetSize()` | **Implemented** | Complete | `PDFPage`'s `set(size:direction:)` instance method |
| `HPDF_Page_SetRotate()` | **Implemented** | Complete | `PDFPage`'s `rotate(byAngle:)` instance method |
| `HPDF_Page_GetWidth()` | **Implemented** | Complete | `PDFPage`'s `width` instance property |
| `HPDF_Page_GetHeight()` | **Implemented** | Complete | `PDFPage`'s `height` instance property |
| `HPDF_Page_CreateDestination()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateTextAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateLinkAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateURILinkAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_TextWidth()` | Unimplemented | None | N/A |
| `HPDF_Page_MeasureText()` | Unimplemented | None | N/A |
| `HPDF_Page_GetGMode()` | **For internal use only** | N/A | N/A |
| `HPDF_Page_GetCurrentPos()` | **Implemented** | Complete | `Path`'s `currentPosition` instance property |
| `HPDF_Page_GetCurrentTextPos()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCurrentFont()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCurrentFontSize()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTransMatrix()` | Unimplemented | None | N/A |
| `HPDF_Page_GetLineWidth()` | **Implemented** | Complete | `DrawingContext`'s `lineWidth` instance property |
| `HPDF_Page_GetLineCap()` | **Implemented** | Complete | `DrawingContext`'s `lineCap` instance property |
| `HPDF_Page_GetLineJoin()` | **Implemented** | Complete | `DrawingContext`'s `lineJoin` instance property |
| `HPDF_Page_GetMiterLimit()` | **Implemented** | Complete | `DrawingContext`'s `miterLimit` instance property |
| `HPDF_Page_GetDash()` | **Implemented** | Complete | `DrawingContext`'s `dashStyle` instance property |
| `HPDF_Page_GetFlat()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCharSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_GetWordSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_GetHorizontalScalling()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextLeading()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextRenderingMode()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextRise()` | Unimplemented | None | N/A |
| `HPDF_Page_GetRGBFill()` | **Implemented** | Complete | `DrawingContext`'s `fillColor` instance property |
| `HPDF_Page_GetRGBStroke()` | **Implemented** | Complete | `DrawingContext`'s `strokeColor` instance property |
| `HPDF_Page_GetCMYKFill()` | **Implemented** | Complete | `DrawingContext`'s `fillColor` instance property |
| `HPDF_Page_GetCMYKStroke()` | **Implemented** | Complete | `DrawingContext`'s `strokeColor` instance property |
| `HPDF_Page_GetGrayFill()` | **Implemented** | Complete | `DrawingContext`'s `fillColor` instance property |
| `HPDF_Page_GetGrayStroke()` | **Implemented** | Complete | `DrawingContext`'s `strokeColor` instance property |
| `HPDF_Page_GetStrokingColorSpace()` | **Implemented** | Complete | `DrawingContext`'s `strokingColorSpace` instance property |
| `HPDF_Page_GetFillingColorSpace()` | **Implemented** | Complete | `DrawingContext`'s `fillingColorSpace` instance property |
| `HPDF_Page_GetTextMatrix()` | Unimplemented | None | N/A |
| `HPDF_Page_GetGStateDepth()` | TBD | None | N/A |
| `HPDF_Page_SetSlideShow()` | Unimplemented | None | N/A |
| `HPDF_Page_New_Content_Stream()` | TBD | None | N/A |
| `HPDF_Page_Insert_Shared_Content_Stream()` | TBD | None | N/A |

## Graphics

| Function  | Status | Test Coverage | SwiftyHaru equivalent |
|-----------|--------|---------------|-----------------------|
| `HPDF_Page_Arc()` | **Implemented** | Complete | `Path`'s `appendArc(center:radius:beginningAngle:endAngle:)` and `arc(x:y:radius:beginningAngle:endAngle:)` instance methods |
| `HPDF_Page_BeginText()` | Unimplemented | None | N/A |
| `HPDF_Page_Circle()` | **Implemented** | Complete | `Path`'s `appendCircle(center:radius:)` and `appendCircle(x:y:radius:)` instance methods |
| `HPDF_Page_Clip()` | Unimplemented | None | N/A |
| `HPDF_Page_ClosePath()` | **Implemented** | Complete | `Path`'s `close()` instance method |
| `HPDF_Page_ClosePathStroke()` | **N/A** | N/A | N/A |
| `HPDF_Page_ClosePathEofillStroke()` | **N/A** | N/A | N/A |
| `HPDF_Page_ClosePathFillStroke()` | **N/A** | N/A | N/A |
| `HPDF_Page_Concat()` | Unimplemented | None | N/A |
| `HPDF_Page_CurveTo()` | **Implemented** | Complete | `Path`'s `appendCurve(controlPoint1:controlPoint2:endPoint:)` instance method |
| `HPDF_Page_CurveTo2()` | **Implemented** | Complete | `Path`'s `appendCurve(controlPoint2:endPoint:)` instance method |
| `HPDF_Page_CurveTo3()` | **Implemented** | Complete | `Path`'s `Curve(controlPoint1:endPoint:)` instance method |
| `HPDF_Page_DrawImage()` | Unimplemented | None | N/A |
| `HPDF_Page_Ellipse()` | **Implemented** | Complete | `Path`'s `appendEllipse(center:horizontalRadius:verticalRadius:)`, `appendEllipse(x:y:horizontalRadius:verticalRadius:)` and `appendEllipse(inscribedIn:)` instance methods |
| `HPDF_Page_EndPath()` | **N/A** | N/A | N/A |
| `HPDF_Page_EndText()` | Unimplemented | None | N/A |
| `HPDF_Page_Eoclip()` | Unimplemented | None | N/A |
| `HPDF_Page_Eofill()` | **Implemented** | Complete | `DrawingContext`'s `fill(_:evenOddRule:stroke:)` instance method |
| `HPDF_Page_EofillStroke()` | **Implemented** | Complete | `DrawingContext`'s `fill(_:evenOddRule:stroke:)` instance method |
| `HPDF_Page_ExecuteXObject()` | Unimplemented | None | N/A |
| `HPDF_Page_Fill()` | **Implemented** | Complete | `DrawingContext`'s `fill(_:evenOddRule:stroke:)` instance method |
| `HPDF_Page_FillStroke()` | **Implemented** | Complete | `DrawingContext`'s `fill(_:evenOddRule:stroke:)` instance method |
| `HPDF_Page_GRestore()` | TBD | None | N/A |
| `HPDF_Page_GSave()` | TBD | None | N/A |
| `HPDF_Page_LineTo()` | **Implemented** | Complete | `Path`'s `appendLine(to:)` instance method |
| `HPDF_Page_MoveTextPos()` | Unimplemented | None | N/A |
| `HPDF_Page_MoveTextPos2()` | Unimplemented | None | N/A |
| `HPDF_Page_MoveTo()` | **Implemented** | Complete | `Path`'s `move(to:)` instance method |
| `HPDF_Page_MoveToNextLine()` | Unimplemented | None | N/A |
| `HPDF_Page_Rectangle()` | **Implemented** | Complete | `Path`'s `appendRectangle(_:)`, `appendRectangle(origin:size:)` and `appendRectangle(x:y:width:height:)` instance methods |
| `HPDF_Page_SetCharSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_SetCMYKFill()` | **Implemented** | Complete | `DrawingContext`'s `fillColor` instance property |
| `HPDF_Page_SetCMYKStroke()` | **Implemented** | Complete | `DrawingContext`'s `strokeColor` instance property |
| `HPDF_Page_SetDash()` | **Implemented** | Complete | `DrawingContext`'s `dashStyle` instance property |
| `HPDF_Page_SetExtGState()` | Unimplemented | None | N/A |
| `HPDF_Page_SetFontAndSize()` | Unimplemented | None | N/A |
| `HPDF_Page_SetGrayFill()` | **Implemented** | Complete | `DrawingContext`'s `fillColor` instance property |
| `HPDF_Page_SetGrayStroke()` | **Implemented** | Complete | `DrawingContext`'s `strokeColor` instance property |
| `HPDF_Page_SetHorizontalScalling()` | Unimplemented | None | N/A |
| `HPDF_Page_SetLineCap()` | **Implemented** | Complete | `DrawingContext`'s `lineCap` instance property |
| `HPDF_Page_SetLineJoin()` | **Implemented** | Complete | `DrawingContext`'s `lineJoin` instance property |
| `HPDF_Page_SetLineWidth()` | **Implemented** | Complete | `DrawingContext`'s `lineWidth` instance property |
| `HPDF_Page_SetMiterLimit()` | **Implemented** | Complete | `DrawingContext`'s `miterLimit` instance property |
| `HPDF_Page_SetRGBFill()` | **Implemented** | Complete | `DrawingContext`'s `fillColor` instance property |
| `HPDF_Page_SetRGBStroke()` | **Implemented** | Complete | `DrawingContext`'s `strokeColor` instance property |
| `HPDF_Page_SetTextLeading()` | Unimplemented | None | N/A |
| `HPDF_Page_SetTextMatrix()` | Unimplemented | None | N/A |
| `HPDF_Page_SetTextRenderingMode()` | Unimplemented | None | N/A |
| `HPDF_Page_SetTextRise()` | Unimplemented | None | N/A |
| `HPDF_Page_SetWordSpace()` | Unimplemented | None | N/A |
| `HPDF_Page_ShowText()` | Unimplemented | None | N/A |
| `HPDF_Page_ShowTextNextLine()` | Unimplemented | None | N/A |
| `HPDF_Page_ShowTextNextLineEx()` | Unimplemented | None | N/A |
| `HPDF_Page_Stroke()` | **Implemented** | Complete | `DrawingContext`'s `stroke(_:)` instance method |
| `HPDF_Page_TextOut()` | Unimplemented | None | N/A |
| `HPDF_Page_TextRect()` | Unimplemented | None | N/A |

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
