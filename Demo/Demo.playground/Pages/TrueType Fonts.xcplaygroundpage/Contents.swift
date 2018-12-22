/*:
 # TrueType Fonts

 **TrueType Fonts** shows how to load and use TrueType font.
 This program uses the font named [Megrim](https://fontlibrary.org/en/font/megrim).

 ([Original example that uses LibHaru](https://github.com/libharu/libharu/wiki/Examples#ttfont_democ))
 */
    import SwiftyHaru
    import Foundation

    let document = PDFDocument()
    let page = document.addPage(width: 210, height: 210)

    let sampleText = "The quick brown fox jumps over the lazy dog."
/*:
 
 
 

 If we set `embedding` to `true`, the glyph data of the font will be
 embedded into the document, so even if you don't have that font
 installed on your system, the text will be displayed using that font.
 
 Try to set this to `false` and observe what happens to the document.
 (We assume that you don't have this font installed.)
 */
    let embedding = true

    try! document.setCompressionMode(to: .all)

    let titleFont = Font.helvetica
/*:
 Let's load our cool font.
 */
    let detailFont = try document
        .loadTrueTypeFont(from: Data(contentsOf: #fileLiteral(resourceName: "Megrim.ttf")),
                          embeddingGlyphData: embedding)
/*:
 Draw the title:
 */
    page.draw { context in

        context.font = titleFont
        context.fontSize = 10

        context.show(text: "\(detailFont.name) (Embedded Subset)",
                     atX: 10, y: 190)
    }
/*:
 And place some text using the loaded font:
 */
    page.draw { context in

        context.font = detailFont
        context.fontSize = 15
        context.show(text: "abcdefghijklmnopqrstuvwxyz", atX: 10, y: 170)
        context.show(text: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", atX: 10, y: 150)
        context.show(text: "1234567890", atX: 10, y: 130)

        context.fontSize = 10
        context.show(text: sampleText, atX: 10, y: 110)

        context.fontSize = 16
        context.show(text: sampleText, atX: 10, y: 92)

        context.fontSize = 23
        context.show(text: sampleText, atX: 10, y: 65)

        context.fontSize = 30
        context.show(text: sampleText, atX: 10, y: 29)

        page.width = context.textWidth(for: sampleText) + 40
    }
/*:
 Separate the different parts of the page with lines:
 */
    page.draw { context in

        context.lineWidth = 0.5

        context.stroke(
            Path()
                .moving(toX: 10, y: page.height - 25)
                .appendingLine(toX: page.width - 10, y: page.height - 25)
        )

        context.stroke(
            Path()
                .moving(toX: 10, y: page.height - 85)
                .appendingLine(toX: page.width - 10, y: page.height - 85)
        )
    }

/*:
 Save our document:
 */
document.display()
/*:
 [Previous page](@previous) • **[Table of contents](Table%20of%20contents)** • [Next page](@next)
 */
