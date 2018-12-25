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
    | `HPDF_SaveToFile()` | **N/A** | N/A | `PDFDocument.getData()` + `Data.write(to:)` |
    | `HPDF_SaveToStream()` | **Implemented** | Complete | `PDFDocument.getData()` |
    | `HPDF_GetStreamSize()` | **For internal use only** | N/A | N/A |
    | `HPDF_ReadFromStream()` | **Implemented** | Complete | `PDFDocument.getData()` |
    | `HPDF_ResetStream()` | **For internal use only** | N/A | N/A |
    | `HPDF_HasDoc()` | **N/A** | N/A | N/A |  |
    | `HPDF_SetErrorHandler()` | **N/A** | N/A | N/A |  |
    | `HPDF_GetError()` | **For internal use only** | N/A | N/A |  |
    | `HPDF_ResetError()` | **For internal use only** | N/A | N/A |  |

* **[Pages Handling](https://github.com/libharu/libharu/wiki/API%3A-Document#Pages_Handling)**

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_SetPagesConfiguration()` | Unimplemented | None | N/A |
    | `HPDF_SetPageLayout()` | **Implemented** | Complete | `PDFDocument.pageLayout` |
    | `HPDF_GetPageLayout()` | **Implemented** | Complete | `PDFDocument.pageLayout` |
    | `HPDF_SetPageMode()` | Unimplemented | None | N/A |
    | `HPDF_GetPageMode()` | Unimplemented | None | N/A |
    | `HPDF_SetOpenAction()` | Unimplemented | None | N/A |
    | `HPDF_GetCurrentPage()` | **N/A** | N/A | N/A |
    | `HPDF_AddPage()` | **Implemented** | Complete | `PDFDocument.addPage(_:)`, `PDFDocument.addPage(width:height:_:)`, `PDFDocument.addPage(size:direction:_:)` |
    | `HPDF_InsertPage()` | **Implemented** | Complete | `PDFDocument.insertPage(atIndex:_:)`, `PDFDocument.insertPage(width:height:atIndex:_:)`, `PDFDocument.insertPage(size:direction:atIndex:_:)` |
    
* **[Font Handling](https://github.com/libharu/libharu/wiki/API%3A-Document#Font_Handling)**

    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_AddPageLabel()` | **Implemented** | Complete | `PDFDocument.addPageLabel(_:fromPage:startingWith:withPrefix)` |
    | `HPDF_GetFont()` | **For internal use only** | N/A | N/A |
    | `HPDF_LoadType1FontFromFile()` | Unimplemented | None | N/A |
    | `HPDF_LoadTTFontFromFile()` | **Implemented** | Complete | `PDFDocument.loadTrueTypeFont(from:embeddingGlyphData:)` |
    | `HPDF_LoadTTFontFromFile2()` | **Implemented** | Complete | `PDFDocument.loadTrueTypeFontFromCollection(from:index:embeddingGlyphData:)` |
    | `HPDF_UseJPFonts()` | Unimplemented | None | N/A |
    | `HPDF_UseKRFonts()` | Unimplemented | None | N/A |
    | `HPDF_UseCNSFonts()` | Unimplemented | None | N/A |
    | `HPDF_UseCNTFonts()` | Unimplemented | None | N/A |

* **[Encodings](https://github.com/libharu/libharu/wiki/API%3A-Document#Encodings)**
    
    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_GetEncoder()` | Unimplemented | None | N/A |
    | `HPDF_GetCurrentEncoder()` | Unimplemented | None | N/A |
    | `HPDF_SetCurrentEncoder()` | Unimplemented | None | N/A |
    | `HPDF_UseJPEncodings()` | **For internal use only** | N/A | N/A |
    | `HPDF_UseKREncodings()` | **For internal use only** | N/A | N/A |
    | `HPDF_UseCNSEncodings()` | **For internal use only** | N/A | N/A |
    | `HPDF_UseCNTEncodings()` | **For internal use only** | N/A | N/A |
    | `HPDF_UseUTFEncodings()` | **For internal use only** | N/A | N/A |

* **[Other Functions](https://github.com/libharu/libharu/wiki/API%3A-Document#Other_Functions)**
    
    | Function  | Status | Test Coverage | SwiftyHaru equivalent |
    |-----------|--------|---------------|-----------------------|
    | `HPDF_CreateOutline()` | Unimplemented | None | N/A |
    | `HPDF_LoadPngImageFromFile()` | Unimplemented | None | N/A |
    | `HPDF_LoadPngImageFromFile2()` | Unimplemented | None | N/A |
    | `HPDF_LoadRawImageFromFile()` | Unimplemented | None | N/A |
    | `HPDF_LoadRawImageFromMem()` | Unimplemented | None | N/A |
    | `HPDF_LoadPngImageFromMem()` | Unimplemented | None | N/A |
    | `HPDF_LoadJpegImageFromMem()` | Unimplemented | None | N/A |
    | `HPDF_LoadJpegImageFromFile()` | Unimplemented | None | N/A |
    | `HPDF_SetInfoAttr()` | **Implemented** | Complete | `PDFDocument.metadata.author`, `PDFDocument.metadata.creator`, `PDFDocument.metadata.title`, `PDFDocument.metadata.subject`, `PDFDocument.metadata.keywords`|
    | `HPDF_GetInfoAttr()` | **Implemented** | Complete | `PDFDocument.metadata.author`, `PDFDocument.metadata.creator`, `PDFDocument.metadata.title`, `PDFDocument.metadata.subject`, `PDFDocument.metadata.keywords`, `PDFDocument.metadata.creationDate`, `PDFDocument.metadata.modificationDate` |
    | `HPDF_SetInfoDateAttr()` | **Implemented** | Complete | `PDFDocument.metadata.creationDate`, `PDFDocument.metadata.modificationDate` |
    | `HPDF_SetPassword()` | **Implemented** | Complete | `PDFDocument.setPassword(owner:user:permissions:encryptionMode:)` |
    | `HPDF_SetPermission()` | **Implemented** | Complete | `PDFDocument.setPassword(owner:user:permissions:encryptionMode:)` |
    | `HPDF_SetEncryptionMode()` | **Implemented** | Complete | `PDFDocument.setPassword(owner:user:permissions:encryptionMode:)` |
    | `HPDF_SetCompressionMode()` | **Implemented** | Incomplete | `PDFDocument.setCompressionMode(to:)` |
`
## Page Handling

| Function  | Status | Test Coverage | SwiftyHaru equivalent |
|-----------|--------|---------------|-----------------------|
| `HPDF_Page_SetWidth()` | **Implemented** | Complete | `PDFPage.width` |
| `HPDF_Page_SetHeight()` | **Implemented** | Complete | `PDFPage.height` |
| `HPDF_Page_SetSize()` | **Implemented** | Complete | `PDFPage.set(size:direction:)` |
| `HPDF_Page_SetRotate()` | **Implemented** | Complete | `PDFPage.rotate(byAngle:)` |
| `HPDF_Page_GetWidth()` | **Implemented** | Complete | `PDFPage.width` |
| `HPDF_Page_GetHeight()` | **Implemented** | Complete | `PDFPage.height` |
| `HPDF_Page_CreateDestination()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateTextAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateLinkAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_CreateURILinkAnnot()` | Unimplemented | None | N/A |
| `HPDF_Page_TextWidth()` | **Implemented** | Complete | `DrawingContext.textWidth(for:)` |
| `HPDF_Page_MeasureText()` | **Implemented** | Incomplete | `DrawingContext.measureText(_:width:wordwrap:)` |
| `HPDF_Page_GetGMode()` | **For internal use only** | N/A | N/A |
| `HPDF_Page_GetCurrentPos()` | **Implemented** | Complete | `Path.currentPosition` |
| `HPDF_Page_GetCurrentTextPos()` | **Implemented** | None | `DrawingContext.currentTextPosition` |
| `HPDF_Page_GetCurrentFont()` | **Implemented** | Complete | `DrawingContext.font` |
| `HPDF_Page_GetCurrentFontSize()` | **Implemented** | Complete | `DrawingContext.fontSize` |
| `HPDF_Page_GetTransMatrix()` | **Implemented** | Complete | `DrawingContext.currentTransform` |
| `HPDF_Page_GetLineWidth()` | **Implemented** | Complete | `DrawingContext.lineWidth` |
| `HPDF_Page_GetLineCap()` | **Implemented** | Complete | `DrawingContext.lineCap` |
| `HPDF_Page_GetLineJoin()` | **Implemented** | Complete | `DrawingContext.lineJoin` |
| `HPDF_Page_GetMiterLimit()` | **Implemented** | Complete | `DrawingContext.miterLimit`|
| `HPDF_Page_GetDash()` | **Implemented** | Complete | `DrawingContext.dashStyle` |
| `HPDF_Page_GetFlat()` | Unimplemented | None | N/A |
| `HPDF_Page_GetCharSpace()` | **Implemented** | Complete | `DrawingContext.characterSpacing` |
| `HPDF_Page_GetWordSpace()` | **Implemented** | None | `DrawingContext.wordSpacing` |
| `HPDF_Page_GetHorizontalScalling()` | Unimplemented | None | N/A |
| `HPDF_Page_GetTextLeading()` | **Implemented** | Complete | `DrawingContext.textLeading` |
| `HPDF_Page_GetTextRenderingMode()` | **Implemented** | Complete | `DrawingContext.textRenderingMode` |
| `HPDF_Page_GetTextRise()` | Unimplemented | None | N/A |
| `HPDF_Page_GetRGBFill()` | **Implemented** | Complete | `DrawingContext.fillColor` |
| `HPDF_Page_GetRGBStroke()` | **Implemented** | Complete | `DrawingContext.strokeColor` |
| `HPDF_Page_GetCMYKFill()` | **Implemented** | Complete | `DrawingContext.fillColor` |
| `HPDF_Page_GetCMYKStroke()` | **Implemented** | Complete | `DrawingContext.strokeColor` |
| `HPDF_Page_GetGrayFill()` | **Implemented** | Complete | `DrawingContext.fillColor` |
| `HPDF_Page_GetGrayStroke()` | **Implemented** | Complete | `DrawingContext.strokeColor` |
| `HPDF_Page_GetStrokingColorSpace()` | **Implemented** | Complete | `DrawingContext.strokingColorSpace` |
| `HPDF_Page_GetFillingColorSpace()` | **Implemented** | Complete | `DrawingContext.fillingColorSpace`|
| `HPDF_Page_GetTextMatrix()` | **N/A** | **N/A** | **N/A** |
| `HPDF_Page_GetGStateDepth()` | **Implemented** | Complete | `DrawingContext.graphicsStateDepth`|
| `HPDF_Page_SetSlideShow()` | Unimplemented | None | N/A |
| `HPDF_Page_New_Content_Stream()` | TBD | None | N/A |
| `HPDF_Page_Insert_Shared_Content_Stream()` | TBD | None | N/A |

## Graphics

| Function  | Status | Test Coverage | SwiftyHaru equivalent |
|-----------|--------|---------------|-----------------------|
| `HPDF_Page_Arc()` | **Implemented** | Complete | `Path.appendArc(center:radius:beginningAngle:endAngle:)`, `Path.arc(x:y:radius:beginningAngle:endAngle:)` |
| `HPDF_Page_BeginText()` | **For internal use only** | N/A | N/A |
| `HPDF_Page_Circle()` | **Implemented** | Complete | `Path.appendCircle(center:radius:)`, `Path.appendCircle(x:y:radius:)` |
| `HPDF_Page_Clip()` | **Implemented** | Complete | `DrawingContext.clip(to:rule:_:)` |
| `HPDF_Page_ClosePath()` | **Implemented** | Complete | `Path.close()` |
| `HPDF_Page_ClosePathStroke()` | **N/A** | N/A | N/A |
| `HPDF_Page_ClosePathEofillStroke()` | **N/A** | N/A | N/A |
| `HPDF_Page_ClosePathFillStroke()` | **N/A** | N/A | N/A |
| `HPDF_Page_Concat()` | **Implemented** | Complete | `DrawingContext.concatenate(_:)`, `DrawingContext.translate(byX:y:)`, `DrawingContext.rotate(byAngle:)`, `DrawingContext.scale(byX:y:)` |
| `HPDF_Page_CurveTo()` | **Implemented** | Complete | `Path.appendCurve(controlPoint1:controlPoint2:endPoint:)` |
| `HPDF_Page_CurveTo2()` | **Implemented** | Complete | `Path.appendCurve(controlPoint2:endPoint:)` |
| `HPDF_Page_CurveTo3()` | **Implemented** | Complete | `Path.appendCurve(controlPoint1:endPoint:)` |
| `HPDF_Page_DrawImage()` | Unimplemented | None | N/A |
| `HPDF_Page_Ellipse()` | **Implemented** | Complete | `Path.appendEllipse(center:horizontalRadius:verticalRadius:)`, `Path.appendEllipse(x:y:horizontalRadius:verticalRadius:)`, `Path.appendEllipse(inscribedIn:)` |
| `HPDF_Page_EndPath()` | **N/A** | N/A | N/A |
| `HPDF_Page_EndText()` | **For internal use only** | N/A | N/A |
| `HPDF_Page_Eoclip()` | **Implemented** | Complete | `DrawingContext.clip(to:rule:_:)` |
| `HPDF_Page_Eofill()` | **Implemented** | Complete | `DrawingContext.fill(_:rule:stroke:)` |
| `HPDF_Page_EofillStroke()` | **Implemented** | Complete | `DrawingContext.fill(_:rule:stroke:)` |
| `HPDF_Page_ExecuteXObject()` | Unimplemented | None | N/A |
| `HPDF_Page_Fill()` | **Implemented** | Complete | `DrawingContext.fill(_:rule:stroke:)` |
| `HPDF_Page_FillStroke()` | **Implemented** | Complete | `DrawingContext.fill(_:rule:stroke:)` |
| `HPDF_Page_GRestore()` | **Implemented** | Complete | `DrawingContext.withNewGState(_:)` |
| `HPDF_Page_GSave()` | **Implemented** | Complete | `DrawingContext.withNewGState(_:)` |
| `HPDF_Page_LineTo()` | **Implemented** | Complete | `Path.appendLine(to:)` |
| `HPDF_Page_MoveTextPos()` | **For internal use only** | None | `DrawingContext.show(text:atPosition:textMatrix:)` |
| `HPDF_Page_MoveTextPos2()` | TBD | None | N/A |
| `HPDF_Page_MoveTo()` | **Implemented** | Complete | `Path.move(to:)` |
| `HPDF_Page_MoveToNextLine()` | Unimplemented | None | N/A |
| `HPDF_Page_Rectangle()` | **Implemented** | Complete | `Path.appendRectangle(_:)`, `Path.appendRectangle(origin:size:)`, `Path.appendRectangle(x:y:width:height:)` |
| `HPDF_Page_SetCharSpace()` | **Implemented** | Complete | `DrawingContext.characterSpacing` |
| `HPDF_Page_SetCMYKFill()` | **Implemented** | Complete | `DrawingContext.fillColor` |
| `HPDF_Page_SetCMYKStroke()` | **Implemented** | Complete | `DrawingContext.strokeColor` |
| `HPDF_Page_SetDash()` | **Implemented** | Complete | `DrawingContext.dashStyle` |
| `HPDF_Page_SetExtGState()` | Unimplemented | None | N/A |
| `HPDF_Page_SetFontAndSize()` | **Implemented** | Complete | `DrawingContext.font`, `DrawingContext.fontSize` |
| `HPDF_Page_SetGrayFill()` | **Implemented** | Complete | `DrawingContext.fillColor` |
| `HPDF_Page_SetGrayStroke()` | **Implemented** | Complete | `DrawingContext.strokeColor` |
| `HPDF_Page_SetHorizontalScalling()` | Unimplemented | None | N/A |
| `HPDF_Page_SetLineCap()` | **Implemented** | Complete | `DrawingContext.lineCap` |
| `HPDF_Page_SetLineJoin()` | **Implemented** | Complete | `DrawingContext.lineJoin` |
| `HPDF_Page_SetLineWidth()` | **Implemented** | Complete | `DrawingContext.lineWidth` |
| `HPDF_Page_SetMiterLimit()` | **Implemented** | Complete | `DrawingContext.miterLimit` |
| `HPDF_Page_SetRGBFill()` | **Implemented** | Complete | `DrawingContext.fillColor` |
| `HPDF_Page_SetRGBStroke()` | **Implemented** | Complete | `DrawingContext.strokeColor` |
| `HPDF_Page_SetTextLeading()` | **Implemented** | Complete | `DrawingContext.textLeading`|
| `HPDF_Page_SetTextMatrix()` | **Implemented** | None | `DrawingContext.show(text:atPosition:textMatrix:)` |
| `HPDF_Page_SetTextRenderingMode()` | **Implemented** | Complete | `DrawingContext.textRenderingMode` |
| `HPDF_Page_SetTextRise()` | Unimplemented | None | N/A |
| `HPDF_Page_SetWordSpace()` | **Implemented** | Complete | `DrawingContext.wordSpacing` |
| `HPDF_Page_ShowText()` | **N/A** | N/A | N/A |
| `HPDF_Page_ShowTextNextLine()` | **Implemented** | None | `DrawingContext.show(text:atPosition:textMatrix:)` |
| `HPDF_Page_ShowTextNextLineEx()` | TBD | N/A | N/A |
| `HPDF_Page_Stroke()` | **Implemented** | Complete | `DrawingContext.stroke(_:)` |
| `HPDF_Page_TextOut()` | **Implemented** | None | `DrawingContext.show(text:atPosition:textMatrix:)` |
| `HPDF_Page_TextRect()` | **Implemented** | Complete | `DrawingContext.show(text:in:alignment:)` |

## Font Handling

| Function  | Status | Test Coverage | SwiftyHaru equivalent |
|-----------|--------|---------------|-----------------------|
| `HPDF_Font_GetFontName()` | **Implemented** | Complete | `Font.name` |
| `HPDF_Font_GetEncodingName()` | **Implemented** | Complete | `Encoding.name` |
| `HPDF_Font_GetUnicodeWidth()` | Unimplemented | None | N/A |
| `HPDF_Font_GetBBox()` | **Implemented** | Complete | `DrawingContext.boundingBox(for:atPosition:)` |
| `HPDF_Font_GetAscent()` | **Implemented** | Complete | `DrawingContext.fontAscent` |
| `HPDF_Font_GetDescent()` | **Implemented** | Complete | `DrawingContext.fontDescent` |
| `HPDF_Font_GetXHeight()` | **Implemented** | Complete | `DrawingContext.fontXHeight` |
| `HPDF_Font_GetCapHeight()` | **Implemented** | Complete | `DrawingContext.fontCapHeight` |
| `HPDF_Font_TextWidth()` | Unimplemented | None | N/A |
| `HPDF_Font_MeasureText()` | Unimplemented | None | N/A |

## Encoding

| Function  | Status | Test Coverage | SwiftyHaru equivalent |
|-----------|--------|---------------|-----------------------|
| `HPDF_Encoder_GetType()` |  TBD | N/A | N/A |
| `HPDF_Encoder_GetByteType()` | TBD | N/A | N/A |
| `HPDF_Encoder_GetUnicode()` | TBD | N/A | N/A |
| `HPDF_Encoder_GetWritingMode()` | TBD | N/A | N/A |

## Annotation

Unimplemented

## Outline

Unimplemented

## Destination

Unimplemented

## Image

Unimplemented
