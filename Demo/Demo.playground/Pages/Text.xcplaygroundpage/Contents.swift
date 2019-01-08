/*:
 # Text

 **Text** is a program which show various way of text showing.

 ([Original example that uses LibHaru](https://github.com/libharu/libharu/wiki/Examples#text_democ))
 */
import SwiftyHaru
import func Foundation.tan
/*:
 Firstly, we need to define some helper functions.
 */
let sampleTextShort  = "ABCabc123"
let sampleTextLong   = "abcdefgABCDEFG123!#$%&+-@?"
let sampleTextPhrase = "The quick brown fox jumps over the lazy dog."

func showStripePattern(in context: DrawingContext, x: Float, y: Float) {

    context.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0.5, alpha: 1)
    context.lineWidth = 1

    for iy in stride(from: 0 as Float, to: 50, by: 3) {
        context.stroke(
            Path()
                .moving(toX: x, y: y + iy)
                .appendingLine(toX: x + context.textWidth(for: sampleTextShort), y: y + iy)
        )
    }

    context.lineWidth = 2.5
}

func showDescription(in context: DrawingContext, x: Float, y: Float, text: String) throws {
    let fontSize = context.fontSize
    let fillColor = context.fillColor

    context.fillColor = .black
    context.textRenderingMode = .fill
    context.fontSize = 10
    try context.show(text: text, atX: x, y: y - 12)

    context.fontSize = fontSize
    context.fillColor = fillColor
}
/*:
 Then we setup our document.
 */
let document = PDFDocument()
let pageTitle = "Text Demo"

try document.setCompressionMode(to: .all)

try document.addPage() { context in

/*:
 Let's draw the grid for convenience.
 */
    let horizontalLabels = sequence(first: 50, next: { $0 + 50 }).lazy.map(String.init)
    let verticalLabels = sequence(first: 10, next: { $0 + 10 }).lazy.map(String.init)

    let labels = Grid.Labels(top: Grid.LabelParameters(sequence: "" + horizontalLabels,
                                                       offset: Vector(dx: 0, dy: -6)),
                             bottom: Grid.LabelParameters(sequence: "" + horizontalLabels,
                                                          offset: Vector(dx: 0, dy: 6)),
                             left: Grid.LabelParameters(sequence: "" + verticalLabels,
                                                        frequency: 1,
                                                        offset: Vector(dx: 6, dy: 0)))

    let serifs = Grid.Serifs(top: .default,
                             bottom: .default,
                             left: Grid.SerifParameters(frequency: 1),
                             right: nil)

    let grid = Grid(width: context.page.width,
                    height: context.page.height,
                    labels: labels,
                    serifs: serifs)
    try context.draw(grid, position: .zero)

/*:
 Let's print the title of the page:
 */

    context.fontSize = 24
    let textWidth = context.textWidth(for: pageTitle)
    try context.show(text: pageTitle, atX: (context.page.width - textWidth) / 2, y: context.page.height - 50)
/*:
 We are now ready to place some text samples.
 First, let's play with font size.
 */
    var textPosition = Point(x: 60, y: context.page.height - 60)

    for fontSize in sequence(first: 8 as Float, next: { $0 * 1.5 }) {

        if fontSize >= 60 {
            break
        }

        context.fontSize = fontSize
        textPosition.y -= 5 + fontSize

        // Measure the number of characters which included in the page
        let utf8Length = try context
            .measureText(sampleTextLong, width: context.page.width - 120, wordwrap: false).utf8Length

        try context.show(text: String(sampleTextLong.utf8.prefix(utf8Length))!, atPosition: textPosition)

        // Print the description
        textPosition.y -= 10
        context.fontSize = 8
        try context.show(text: String(format: "Fontsize=%.0f", fontSize), atPosition: textPosition)
    }
/*:
 Then let's experiment with font color.
 */
    context.fontSize = 8
    textPosition.y -= 30
    try context.show(text: "Font color", atPosition: textPosition)

    context.fontSize = 18
    textPosition.y -= 20
    for (i, char) in sampleTextLong.enumerated() {
        let char = String(char)
        let red = Float(i) / Float(sampleTextLong.utf8.count)
        let green = 1 - red
        context.fillColor = Color(red: red, green: green, blue: 0)!
        try context.show(text: char, atPosition: textPosition)
        textPosition.x += context.textWidth(for: char)
    }

    textPosition.x = 60
    textPosition.y -= 25
    for (i, char) in sampleTextLong.enumerated() {
        let char = String(char)
        let red = Float(i) / Float(sampleTextLong.utf8.count)
        let blue = 1 - red
        context.fillColor = Color(red: red, green: 0, blue: blue)!
        try context.show(text: char, atPosition: textPosition)
        textPosition.x += context.textWidth(for: char)
    }

    textPosition.x = 60
    textPosition.y -= 25
    for (i, char) in sampleTextLong.enumerated() {
        let char = String(char)
        let blue = Float(i) / Float(sampleTextLong.utf8.count)
        let green = 1 - blue
        context.fillColor = Color(red: 0, green: green, blue: blue)!
        try context.show(text: char, atPosition: textPosition)
        textPosition.x += context.textWidth(for: char)
    }
/*:
 Explore different font rendering modes:
 */
    let ypos: Float = 450

    context.fontSize = 32
    context.fillColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0, alpha: 1)
    context.lineWidth

    try showDescription(in: context, x: 60, y: ypos, text: "textRenderingMode = .fill")
    context.textRenderingMode = .fill
    try context.show(text: sampleTextShort, atX: 60, y: ypos)

    try showDescription(in: context, x: 60, y: ypos - 50, text: "textRenderingMode = .stroke")
    context.textRenderingMode = .stroke
    try context.show(text: sampleTextShort, atX: 60, y: ypos - 50)

    try showDescription(in: context, x: 60, y: ypos - 100, text: "textRenderingMode = .fillThenStroke")
    context.textRenderingMode = .fillThenStroke
    try context.show(text: sampleTextShort, atX: 60, y: ypos - 100)

    try showDescription(in: context, x: 60, y: ypos - 150, text: "textRenderingMode = .fillClipping")
    try context.withNewGState {
        context.textRenderingMode = .fillClipping
        try context.show(text: sampleTextShort, atX: 60, y: ypos - 150)
        showStripePattern(in: context, x: 60, y: ypos - 150)
    }

    try showDescription(in: context, x: 60, y: ypos - 200, text: "textRenderingMode = .strokeClipping")
    try context.withNewGState {
        context.textRenderingMode = .strokeClipping
        try context.show(text: sampleTextShort, atX: 60, y: ypos - 200)
        showStripePattern(in: context, x: 60, y: ypos - 200)
    }

    try showDescription(in: context, x: 60, y: ypos - 250, text: "textRenderingMode = .fillStrokeClipping")
    try context.withNewGState {
        context.textRenderingMode = .fillStrokeClipping
        try context.show(text: sampleTextShort, atX: 60, y: ypos - 250)
        showStripePattern(in: context, x: 60, y: ypos - 250)
    }

/*:
 Reset text attributes and try to transform text in different ways:
 */
    context.textRenderingMode = .fill
    context.fillColor = .black
    context.fontSize = 30

    try showDescription(in: context, x: 320, y: ypos - 60, text: "Rotating text")
    let rotatedTextPosition = Point(x: 330, y: ypos - 60)
    let rotatedTextMatrix = AffineTransform(rotationAngle: .pi / 6) *
        AffineTransform(translationX: rotatedTextPosition.x, y: rotatedTextPosition.y)
    try context.show(text: sampleTextShort,
                     atPosition: rotatedTextPosition,
                     textMatrix: rotatedTextMatrix)

    try showDescription(in: context, x: 320, y: ypos - 120, text: "Skewing text")
    let skewedTextPosition = Point(x: 330, y: ypos - 120)
    let skewedTextMatrix = AffineTransform(a:  1,                    b:  tan(.pi / 18),
                                           c:  tan(.pi / 9),         d:  1,
                                           tx: skewedTextPosition.x, ty: skewedTextPosition.y)
    try context.show(text: sampleTextShort,
                     atPosition: skewedTextPosition,
                     textMatrix: skewedTextMatrix)

    try showDescription(in: context, x: 320, y: ypos - 175, text: "Scaling text (X direction)")
    let scaledXTextPosition = Point(x: 320, y: ypos - 175)
    let scaledXTextMatrix = AffineTransform(scaleX: 1.5, y: 1) *
        AffineTransform(translationX: scaledXTextPosition.x, y: scaledXTextPosition.y)
    try context.show(text: sampleTextShort,
                     atPosition: scaledXTextPosition,
                     textMatrix: scaledXTextMatrix)

    try showDescription(in: context, x: 320, y: ypos - 250, text: "Scaling text (Y direction)")
    let scaledYTextPosition = Point(x: 320, y: ypos - 250)
    let scaledYTextMatrix = AffineTransform(scaleX: 1, y: 2) *
        AffineTransform(translationX: scaledYTextPosition.x, y: scaledYTextPosition.y)
    try context.show(text: sampleTextShort,
                     atPosition: scaledYTextPosition,
                     textMatrix: scaledYTextMatrix)

/*:
 Alter character spacing and word spacing:
 */

    try showDescription(in: context, x: 60, y: 140, text: "char-spacing 0")
    try showDescription(in: context, x: 60, y: 100, text: "char-spacing 1.5")
    try showDescription(in: context, x: 60, y: 60,  text: "char-spacing 1.5, word-spacing 2.5")

    context.fontSize = 20
    context.fillColor = #colorLiteral(red: 0.1, green: 0.3, blue: 0.1, alpha: 1)

    context.characterSpacing = 0
    try context.show(text: sampleTextPhrase, atX: 60, y: 140)

    context.characterSpacing = 1.5
    try context.show(text: sampleTextPhrase, atX: 60, y: 100)

    context.wordSpacing = 2.5
    try context.show(text: sampleTextPhrase, atX: 60, y: 60)
}

/*:
 We need to save our document.
 */
document.display()
/*:
 [Previous page](@previous) • **[Table of contents](Table%20of%20contents)** • [Next page](@next)
 */
