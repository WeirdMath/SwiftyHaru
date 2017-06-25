/*:
 # Arcs

 **Arcs** is a program which shows how to use arc and circle functions.

 ([Original example that uses LibHaru](https://github.com/libharu/libharu/wiki/Examples#arc_democ))
 */
    import SwiftyHaru

    let document = PDFDocument()
    let page = document.addPage(width: 200, height: 220)
/*:
 Let's draw the grid for convenience.
 */

    let horizontalLabels = stride(from: 50, through: 150, by: 50).map(String.init)
    let verticalLabels = stride(from: 10, through: 210, by: 10).map(String.init)

    let labels = Grid.Labels(top: Grid.LabelParameters(sequence: "" + horizontalLabels,
                                                       offset: Vector(x: 0, y: -6)),
                             bottom: Grid.LabelParameters(sequence: "" + horizontalLabels,
                                                          offset: Vector(x: 0, y: 6)),
                             left: Grid.LabelParameters(sequence: "" + verticalLabels,
                                                        frequency: 1,
                                                        offset: Vector(x: 6, y: 0)))

    let serifs = Grid.Serifs(top: .default,
                             bottom: .default,
                             left: Grid.SerifParameters(frequency: 1),
                             right: nil)

    let grid = Grid(width: page.width, height: page.height, labels: labels, serifs: serifs)
    page.draw(object: grid, position: .zero)
/*:
 Then draw a pie chart.
 - a: 45% red
 - b: 25% blue
 - c: 15% green
 - d: other yellow
 */

    let center = Point(x: 100, y: 100)

    var temporaryPosition: Point

    var a = Path()
        .moving(to: center)
        .appendingLine(toX: 100, y: 180)
        .appendingArc(center: center,
                      radius: 80,
                      beginningAngle: 0,
                      endAngle: 360 * 0.45)
    temporaryPosition = a.currentPosition
    a.appendLine(to: center)

    var b = Path()
        .moving(to: center)
        .appendingLine(to: temporaryPosition)
        .appendingArc(center: center, radius: 80, beginningAngle: 360 * 0.45, endAngle: 360 * 0.7)
    temporaryPosition = b.currentPosition
    b.appendLine(to: center)

    var c = Path()
        .moving(to: center)
        .appendingLine(to: temporaryPosition)
        .appendingArc(center: center, radius: 80, beginningAngle: 360 * 0.7, endAngle: 360 * 0.85)
    temporaryPosition = c.currentPosition
    c.appendLine(to: center)

    var d = Path()
        .moving(to: center)
        .appendingLine(to: temporaryPosition)
        .appendingArc(center: center, radius: 80, beginningAngle: 360 * 0.85, endAngle: 360)
        .appendingLine(to: center)

    // Draw center circle
    let centerCircle = Path().appendingCircle(center: center, radius: 30)

    page.draw { context in

        context.fillColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        context.fill(a)

        context.fillColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        context.fill(b)

        context.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        context.fill(c)

        context.fillColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        context.fill(d)

        context.fillColor = .white
        context.fill(centerCircle)
    }
/*:
 Save our document:
 */
    document.display()
/*:
  [Previous page](@previous) • **[Table of contents](Table%20of%20contents)** • [Next page](@next)
 */