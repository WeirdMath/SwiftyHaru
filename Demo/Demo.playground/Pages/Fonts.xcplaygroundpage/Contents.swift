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
    let page = document.addPage()
    let pageTitle = "Font Demo"

/*:
 Print the lines and the title of the page:
 */
    page.draw { context in

        let rectangle = Path()
            .appendingRectangle(x: 50,
                                y: 50,
                                width: page.width - 100,
                                height: page.height - 110)

        context.stroke(rectangle)

        context.fontSize = 24
        let textWidth = context.textWidth(for: pageTitle)
        context.show(text: pageTitle,
                     atX: (page.width - textWidth) / 2,
                     y: page.height - 50)
    }
/*:
 Output subtitle:
 */
    page.draw { context in

        context.fontSize = 16
        context.show(text: "<Standerd Type1 fonts samples>",
                     atX: 60,
                     y: page.height - 80)
}
/*:
 And finally let's test each font:
 */
    page.draw { context in

        var textPosition = Point(x: 60, y: page.height - 105)

        let sampleText = "abcdefgABCDEFG12345!#$%&+-@?"

        for font in fontList {

            context.fontSize = 9
            context.font = .helvetica
            context.show(text: font.name, atPosition: textPosition)
            textPosition = textPosition + Vector(x: 0, y: -18)

            context.fontSize = 20
            context.font = font
            context.show(text: sampleText, atPosition: textPosition)
            textPosition = textPosition + Vector(x: 0, y: -20)
        }
    }
/*:
 Save our document.
 */
    document.display()
/*:
 [Previous page](@previous) • **[Table of contents](Table%20of%20contents)** • [Next page](@next)
 */
