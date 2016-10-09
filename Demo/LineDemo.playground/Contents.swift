import SwiftyHaru

let document = SwiftyHaru.PDFDocument()
let page = document.addPage()

page.draw { context in
    let rectangle = Path().appendingRectangle(x: 50, y: 50, width: page.width - 100, height: page.height - 110)
    context.stroke(rectangle)
}

func drawLine(in context: DrawingContext, x: Float, y: Float, label: String) {
    let line = Path().moving(toX: x, y: y - 15).appendingLine(toX: x + 220, y: y - 15)
    context.stroke(line)
}

func drawLine2(in context: DrawingContext, x: Float, y: Float, label: String) {
    let line = Path().moving(toX: x + 30, y: y - 25).appendingLine(toX: x + 160, y: y - 25)
    context.stroke(line)
}

func constructRect(in context: DrawingContext, x: Float, y: Float, label: String) -> Path {
    return Path().appendingRectangle(x: x, y: y - 40, width: 220, height: 25)
}

page.draw { context in
    
    context.lineWidth = 0
    drawLine(in: context, x: 60, y: 770, label: "lineWidth == 0")
    
    context.lineWidth = 1
    drawLine(in: context, x: 60, y: 740, label: "lineWidth == 1")
    
    context.lineWidth = 2
    drawLine(in: context, x: 60, y: 710, label: "lineWidth == 2")
}

page.draw { context in
    context.dashStyle = DashStyle(pattern: [3], phase: 1)!
    drawLine(in: context, x: 60, y: 680, label: "dashStyle.pattern == [3], dashStyle.phase == 1 | 2 on, 3 off, 3 on...")
    
    context.dashStyle = DashStyle(pattern: [3, 7], phase: 2)!
    drawLine(in: context, x: 60, y: 650, label: "dashStyle.pattern == [7, 3], dashStyle.phase == 2 | 5 on 3 off, 7 on,...")
    
    context.dashStyle = DashStyle(pattern: [8, 7, 2, 7])!
    drawLine(in: context, x: 60, y: 620, label: "dashStyle.pattern == [8, 7, 2, 7], dashStyle.phase == 0")
}

page.draw { context in
    
    context.lineWidth = 30
    context.strokeColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0, alpha: 1)
    
    context.lineCap = .butt
    drawLine2(in: context, x: 60, y: 570, label: "LineCap.butt")
    
    context.lineCap = .round
    drawLine2(in: context, x: 60, y: 505, label: "LineCap.round")
    
    context.lineCap = .projectingSquare
    drawLine2(in: context, x: 60, y: 440, label: "LineCap.projectingSquare")
}

page.draw { context in
    
    context.lineWidth = 30
    context.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0.4980392157, alpha: 1)
    
    context.lineJoin = .miter
    
    let miterPath = Path()
        .moving(toX: 120, y: 300)
        .appendingLine(toX: 160, y: 340)
        .appendingLine(toX: 200, y: 300)
    
    context.stroke(miterPath)
    
    context.lineJoin = .round
    
    let roundPath = Path()
        .moving(toX: 120, y: 195)
        .appendingLine(toX: 160, y: 235)
        .appendingLine(toX: 200, y: 195)
    
    context.stroke(roundPath)
    
    context.lineJoin = .bevel
    
    let bevelPath = Path()
        .moving(toX: 120, y: 90)
        .appendingLine(toX: 160, y: 130)
        .appendingLine(toX: 200, y: 90)
    
    context.stroke(bevelPath)
}

page.draw { context in
    context.lineWidth = 2
    context.strokeColor = .black
    context.fillColor = #colorLiteral(red: 0.7529411765, green: 0, blue: 0, alpha: 1)
    
    let strokeRectangle = constructRect(in: context, x: 300, y: 770, label: "Stroke")
    context.stroke(strokeRectangle)
    
    let fillRectangle = constructRect(in: context, x: 300, y: 720, label: "Fill")
    context.fill(fillRectangle)
    
    let fillStrokeRectangle = constructRect(in: context, x: 300, y: 670, label: "Fill and Stroke")
    context.fill(fillStrokeRectangle, stroke: true)
    
    let clipRectangle = constructRect(in: context, x: 300, y: 620, label: "Clip Rectangle")
    context.stroke(clipRectangle)
}

page.draw { context in
    
    var point = Point(x: 330, y: 440)
    var point1 = Point(x: 430, y: 530)
    var point2 = Point(x: 480, y: 470)
    let point3 = Point(x: 480, y: 90)
    
    context.dashStyle = DashStyle(pattern: [3])!
    context.lineWidth = 0.5
    
    context.stroke(Path().moving(to: point1).appendingLine(to: point2))
    
    context.dashStyle = .straightLine
    context.lineWidth = 1.5
    
    context.stroke(Path().moving(to: point).appendingCurve(controlPoint2: point1, endPoint: point2))
    
    point = point + Vector(x: 0, y: -150)
    point1 = point1 + Vector(x: 0, y: -150)
    point2 = point2 + Vector(x: 0, y: -150)
    
    context.dashStyle = DashStyle(pattern: [3])!
    context.lineWidth = 0.5
    
    context.stroke(Path().moving(to: point).appendingLine(to: point1))
    
    context.dashStyle = .straightLine
    context.lineWidth = 1.5
    
    context.stroke(Path().moving(to: point).appendingCurve(controlPoint1: point1, endPoint: point2))
    
    point = point + Vector(x: 0, y: -150)
    point1 = point1 + Vector(x: 0, y: -160)
    point2 = point2 + Vector(x: 10, y: -130)
    
    context.dashStyle = DashStyle(pattern: [3])!
    context.lineWidth = 0.5
    
    context.stroke(Path().moving(to: point).appendingLine(to: point1).moving(to: point2).appendingLine(to: point3))
    
    context.dashStyle = .straightLine
    context.lineWidth = 1.5
    
    context.stroke(Path().moving(to: point).appendingCurve(controlPoint1: point1, controlPoint2: point2, endPoint: point3))
}

document.display()
