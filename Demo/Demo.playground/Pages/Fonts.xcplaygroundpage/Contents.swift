/*:
 # Fonts

 **Fonts** is a program which shows a list of base 14 fonts.
 
 ([Original example that uses LibHaru](https://github.com/libharu/libharu/wiki/Examples#font_democ))
 */
    import SwiftyHaru
/*:
 Define our list of fonts:
 */
    let fontList: [Font] = [
        .courier,
        .courierBold,
        .courierOblique,
        .courierBoldOblique,
        .helvetica,
        .helveticaBold,
        .helveticaOblique,
        .helveticaBoldOblique,
        .timesRoman,
        .timesBold,
        .timesItalic,
        .timesBoldItalic,
        .symbol,
        .zapfDingbats
    ]
/*:
 Setup our document:
 */
    let document = PDFDocument()
    let pageTitle = "Font Demo"

    try document.addPage { context in
/*:
 Print the lines and the title of the page:
 */
        let rectangle = Path()
            .appendingRectangle(x: 50,
                                y: 50,
                                width: context.page.width - 100,
                                height: context.page.height - 110)

        context.stroke(rectangle)

        context.textLeading = 11
        context.fontSize = 24
        let textWidth = context.textWidth(for: pageTitle)
        try context.show(text: pageTitle,
                         atX: (context.page.width - textWidth) / 2,
                         y: context.page.height - 50)
/*:
 Output subtitle:
 */
        context.fontSize = 16
        try context.show(text: "<Standerd Type1 fonts samples>",
                         atX: 60,
                         y: context.page.height - 80)
/*:
 And finally let's test each font:
 */
        var textPosition = Point(x: 60, y: context.page.height - 105)

        let sampleText = "abcdefgABCDEFG12345!#$%&+-@?"

        for font in fontList {

            context.fontSize = 9
            context.font = .helvetica
            try context.show(text: font.name, atPosition: textPosition)
            textPosition = textPosition + Vector(dx: 0, dy: -18)

            context.fontSize = 20
            context.font = font
            try context.show(text: sampleText, atPosition: textPosition)
            textPosition = textPosition + Vector(dx: 0, dy: -20)
        }
    }
/*:
 Save our document.
 */
    document.display()
/*:
 [Previous page](@previous) • **[Table of contents](Table%20of%20contents)** • [Next page](@next)
 */
