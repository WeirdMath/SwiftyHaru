import SwiftyHaru

func createLabelSequence(stride: Int) -> AnySequence<String> {
    
    let seq = sequence(first: 0, next: { $0 + stride }).lazy.map(String.init)
    
    return "" + AnySequence(seq).dropFirst()
}

let document = PDFDocument()
let page = document.addPage(width: 400, height: 600)

let topLabelParameters =
    Grid.LabelParameters(sequence: createLabelSequence(stride: 50),
                         frequency: 5,
                         offset: Vector(x: 0, y: -6))

let bottomLabelParameters =
    Grid.LabelParameters(sequence: createLabelSequence(stride: 50),
                         frequency: 5,
                         offset: Vector(x: 0, y: 6))

let leftLabelParameters =
    Grid.LabelParameters(sequence: createLabelSequence(stride: 10),
                         frequency: 1,
                         offset: Vector(x: 6, y: 0))

let labels = Grid.Labels(top: topLabelParameters,
                         bottom: bottomLabelParameters,
                         left: leftLabelParameters,
                         right: nil)

let verticalSerifParameters = Grid.SerifParameters(frequency: 1)
let horizontalSerifParameters = Grid.SerifParameters(frequency: 5)

let serifs = Grid.Serifs(top: horizontalSerifParameters,
                         bottom: horizontalSerifParameters,
                         left: verticalSerifParameters,
                         right: nil)

let grid = Grid(width: page.width,
                height: page.height,
                labels: labels,
                serifs: serifs)

page.draw(object: grid, position: .zero)

document.display()
