/*:
 # Lines
 
 **Lines** is a program which shows various line graphics.
 
 ([Original example that uses LibHaru](https://github.com/libharu/libharu/wiki/Examples#line_democ))
 */
    import SwiftyHaru
/*:
 Firstly, we need to define some helper functions.
 */
    func drawLine(in context: DrawingContext,
                  x: Float,
                  y: Float,
                  label: String) throws {

        let line = Path()
            .moving(toX: x, y: y - 15)
            .appendingLine(toX: x + 220, y: y - 15)

        context.stroke(line)
        context.fontSize = 10
        try context.show(text: label, atX: x, y: y - 10)
    }

    func drawLine2(in context: DrawingContext,
                   x: Float,
                   y: Float,
                   label: String) throws {

        let line = Path()
            .moving(toX: x + 30, y: y - 25)
            .appendingLine(toX: x + 160, y: y - 25)

        context.stroke(line)
        try context.show(text: label, atX: x, y: y)
    }

    func constructRect(in context: DrawingContext,
                       x: Float,
                       y: Float,
                       label: String) throws -> Path {

        try context.show(text: label, atX: x, y: y - 10)
        return Path().appendingRectangle(x: x, y: y - 40, width: 220, height: 25)
    }
/*: 
 Then we setup our document.
 */
    let document = PDFDocument()
    let pageTitle = "Line Example"

    try document.addPage() { context in
/*:
 Let's print the lines of the page…
 */
        let rectangle = Path()
            .appendingRectangle(x: 30,
                                y: 50,
                                width: context.page.width - 60,
                                height: context.page.height - 110)
        context.stroke(rectangle)

/*:
 …and the title of the page (with positioning center).
 */
        context.textLeading = 11
        context.fontSize = 24

        let textWidth = context.textWidth(for: pageTitle)
        let position = Point(x: (context.page.width - textWidth) / 2,
                             y: context.page.height - 50)

        try context.show(text: pageTitle, atPosition: position)
/*:
 Draw various widths of lines.
 */

        context.lineWidth = 0
        try drawLine(in: context, x: 60, y: 770, label: "lineWidth == 0")

        context.lineWidth = 1
        try drawLine(in: context, x: 60, y: 740, label: "lineWidth == 1")

        context.lineWidth = 2
        try drawLine(in: context, x: 60, y: 710, label: "lineWidth == 2")

        context.lineWidth = DrawingContext.defaultLineWidth
/*:
 We can alternate line dash pattern:
 */
        context.dashStyle = DashStyle(pattern: [3], phase: 1)!
        try drawLine(in: context, x: 60, y: 680,
                     label: "pattern == [3], phase == 1: 2 on, 3 off, 3 on...")

        context.dashStyle = DashStyle(pattern: [7, 3], phase: 2)!
        try drawLine(in: context, x: 60, y: 650,
                     label: "pattern == [7, 3], phase == 2: 5 on, 3 off, 7 on,...")

        context.dashStyle = DashStyle(pattern: [8, 7, 2, 7])!
        try drawLine(in: context, x: 60, y: 620,
                     label: "pattern == [8, 7, 2, 7], phase == 0")

        context.dashStyle = .straightLine

        context.lineWidth = 30
        context.strokeColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0, alpha: 1)

        context.lineCap = .butt
        try drawLine2(in: context,
                      x: 60,
                      y: 570,
                      label: "LineCap.butt")

        context.lineCap = .round
        try drawLine2(in: context,
                      x: 60,
                      y: 505,
                      label: "LineCap.round")

        context.lineCap = .projectingSquare
        try drawLine2(in: context,
                      x: 60,
                      y: 440,
                      label: "LineCap.projectingSquare")
/*:
 And join style:
 */
        context.lineWidth = 30
        context.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0.4980392157, alpha: 1)

        context.lineJoin = .miter

        let miterPath = Path()
            .moving(toX: 120, y: 300)
            .appendingLine(toX: 160, y: 340)
            .appendingLine(toX: 200, y: 300)

        context.stroke(miterPath)
        try context.show(text: "LineJoin.miter", atX: 60, y: 360)

        context.lineJoin = .round

        let roundPath = Path()
            .moving(toX: 120, y: 195)
            .appendingLine(toX: 160, y: 235)
            .appendingLine(toX: 200, y: 195)

        context.stroke(roundPath)
        try context.show(text: "LineJoin.round", atX: 60, y: 255)

        context.lineJoin = .bevel

        let bevelPath = Path()
            .moving(toX: 120, y: 90)
            .appendingLine(toX: 160, y: 130)
            .appendingLine(toX: 200, y: 90)

        context.stroke(bevelPath)
        try context.show(text: "LineJoin.bevel", atX: 60, y: 150)
/*:
 Let's draw some rectangles.
 */
        context.lineWidth = 2
        context.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        context.fillColor = #colorLiteral(red: 0.7529411765, green: 0, blue: 0, alpha: 1)

        let strokeRectangle = try constructRect(in: context,
                                                x: 300,
                                                y: 770,
                                                label: "Stroke")
        context.stroke(strokeRectangle)

        let fillRectangle = try constructRect(in: context,
                                              x: 300,
                                              y: 720,
                                              label: "Fill")
        context.fill(fillRectangle)

        let fillStrokeRectangle = try constructRect(in: context,
                                                    x: 300,
                                                    y: 670,
                                                    label: "Fill and Stroke")

        context.fill(fillStrokeRectangle, stroke: true)
/*:
 And clip text to a rectangle:
 */
        context.lineWidth = 2
        context.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        context.fillColor = #colorLiteral(red: 0.7529411765, green: 0, blue: 0, alpha: 1)

        let clipRectangle = try constructRect(in: context,
                                              x: 300,
                                              y: 620,
                                              label: "Clip Rectangle")
        context.stroke(clipRectangle)

        try context.clip(to: clipRectangle) {

            context.fontSize = 13
            context.textLeading = 12
            try context.show(text: """
                             Clip Clip Clip Clip Clip Clip Clip Clip Clip
                             Clip Clip Clip Clip Clip Clip Clip Clip Clip
                             Clip Clip Clip Clip Clip Clip Clip Clip Clip
                             """,
                             atX: 290, y: 600)
        }
/*:
 Finally, let's play with some curves.
 */
        // Curve example (appendingCurve(controlPoint2:endPoint:))
        var point  = Point(x: 330, y: 440)
        var point1 = Point(x: 430, y: 530)
        var point2 = Point(x: 480, y: 470)
        let point3 = Point(x: 480, y: 90)

        try context.show(text: "appendCurve(controlPoint2:endPoint:)",
                         atX: 300, y: 550)

        var currentPoint = Point(x: point.x + 5, y: point.y - 5)
        try context.show(text: "currentPosition", atPosition: currentPoint)
        currentPoint = currentPoint + (point1 - point)
        try context.show(text: "controlPoint2", atPosition: currentPoint)
        currentPoint = currentPoint + (point2 - point1)
        try context.show(text: "endPoint", atPosition: currentPoint)

        context.dashStyle = DashStyle(pattern: [3])!
        context.lineWidth = 0.5

        context.stroke(Path().moving(to: point1).appendingLine(to: point2))

        context.dashStyle = .straightLine
        context.lineWidth = 1.5

        context.stroke(
            Path()
                .moving(to: point)
                .appendingCurve(controlPoint2: point1, endPoint: point2)
        )

        // Curve example (appendingCurve(controlPoint1:endPoint))
        point  = point  + Vector(dx: 0, dy: -150)
        point1 = point1 + Vector(dx: 0, dy: -150)
        point2 = point2 + Vector(dx: 0, dy: -150)

        try context.show(text: "appendCurve(controlPoint1:endPoint)",
                         atX: 300, y: 400)

        currentPoint = Point(x: point.x + 5, y: point.y - 5)
        try context.show(text: "currentPosition", atPosition: currentPoint)
        currentPoint = currentPoint + (point1 - point)
        try context.show(text: "controlPoint1", atPosition: currentPoint)
        currentPoint = currentPoint + (point2 - point1)
        try context.show(text: "endPoint", atPosition: currentPoint)

        context.dashStyle = DashStyle(pattern: [3])!
        context.lineWidth = 0.5

        context.stroke(Path().moving(to: point).appendingLine(to: point1))

        context.dashStyle = .straightLine
        context.lineWidth = 1.5

        context.stroke(
            Path()
                .moving(to: point)
                .appendingCurve(controlPoint1: point1, endPoint: point2)
        )

        // Curve example (appendCurve(controlPoint1:controlPoint2:endPoint))
        point = point + Vector(dx: 0, dy: -150)
        point1 = point1 + Vector(dx: 0, dy: -160)
        point2 = point2 + Vector(dx: 10, dy: -130)

        try context.show(text: "appendCurve(controlPoint1:controlPoint2:endPoint)",
                         atX: 300, y: 250)
        currentPoint = Point(x: point.x + 5, y: point.y - 5)
        try context.show(text: "currentPosition", atPosition: currentPoint)
        currentPoint = currentPoint + (point1 - point)
        try context.show(text: "controlPoint1", atPosition: currentPoint)
        currentPoint = currentPoint + (point2 - point1)
        try context.show(text: "controlPoint2", atPosition: currentPoint)
        currentPoint = currentPoint + (point3 - point2)
        try context.show(text: "endPoint", atPosition: currentPoint)

        context.dashStyle = DashStyle(pattern: [3])!
        context.lineWidth = 0.5

        context.stroke(
            Path()
                .moving(to: point)
                .appendingLine(to: point1)
                .moving(to: point2)
                .appendingLine(to: point3)
        )

        context.dashStyle = .straightLine
        context.lineWidth = 1.5

        context.stroke(
            Path()
                .moving(to: point)
                .appendingCurve(controlPoint1: point1,
                                controlPoint2: point2,
                                endPoint: point3)
        )
    }
/*:
 We need to save our document.
 */
    document.display()
/*:
[Previous page](@previous) • **[Table of contents](Table%20of%20contents)** • [Next page](@next)
 */
