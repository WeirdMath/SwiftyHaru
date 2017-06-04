/*:
 # Grid Sheet

 **Grid Sheet** is a program which uses to design a report.
 A positioning works becomes easy by overlaying a page with this grid sheet

 ([Original example that uses LibHaru](https://github.com/libharu/libharu/wiki/Examples#grid_sheetc))
 */
    import SwiftyHaru
/*:
 We need a function that generates the grid's labels with a given stride.
 */
    func createLabelSequence(stride: Int) -> AnySequence<String> {
        
        let seq = sequence(first: stride, next: { $0 + stride }).lazy.map(String.init)
        
        return "" + AnySequence(seq)
    }
/*:
 Let's setup our document.
 */
    let document = PDFDocument()
    let page = document.addPage(width: 400, height: 600)
/*:
 And set some parameters
 */
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
/*:
 Finally, assemble everything:
 */
    let grid = Grid(width: page.width,
                    height: page.height,
                    labels: labels,
                    serifs: serifs)

    page.draw(object: grid, position: .zero)
/*:
 Yep, it's that simple.
 
 Now save our PDF.
 */
    document.display()
/*:
 [Previous page](@previous) • **[Table of contents](Table%20of%20contents)**
 */
