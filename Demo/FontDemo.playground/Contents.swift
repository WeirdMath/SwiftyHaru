import SwiftyHaru

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

let document = PDFDocument()
let page = document.addPage()
let pageTitle = "Font Demo"

page.draw { context in
    
    // Print the lines of the page.
    let rectangle = Path()
        .appendingRectangle(x: 50,
                            y: 50,
                            width: page.width - 100,
                            height: page.height - 110)
    
    context.stroke(rectangle)
    
    // Print the title of the page (with positioning center).
    context.fontSize = 24
    let textWidth = context.textWidth(for: pageTitle)
    context.show(text: pageTitle,
                 atX: (page.width - textWidth) / 2,
                 y: page.height - 50)
}

// Output subtitle.
page.draw { context in
    
    context.fontSize = 16
    context.show(text: "<Standerd Type1 fonts samples>",
                 atX: 60,
                 y: page.height - 80)
}

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

document.display()
