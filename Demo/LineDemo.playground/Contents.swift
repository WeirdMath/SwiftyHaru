import SwiftyHaru

let document = SwiftyHaru.PDFDocument()
let page = document.addPage()

page.drawPath { context in
    
    context.rectangle(x: 50, y: 50, width: page.width - 100, height: page.height - 110)
    context.strokePath()
}

func drawLine(in context: PDFPathContext, x: Float, y: Float, label: String) {
    
    context.move(toX: x, y: y - 15)
    context.line(toX: x + 220, y: y - 15)
    context.strokePath()
}

func drawLine2(in context: PDFPathContext, x: Float, y: Float, label: String) {
    
    context.move(toX: x + 30, y: y - 25)
    context.line(toX: x + 160, y: y - 25)
    context.strokePath()
}

func drawRect(in context: PDFPathContext, x: Float, y: Float, label: String) {
    
    context.rectangle(x: x, y: y - 40, width: 220, height: 25)
}

page.drawPath { context in
    
    context.lineWidth = 0
    drawLine(in: context, x: 60, y: 770, label: "lineWidth == 0")
    
    context.lineWidth = 1
    drawLine(in: context, x: 60, y: 740, label: "lineWidth == 1")
    
    context.lineWidth = 2
    drawLine(in: context, x: 60, y: 710, label: "lineWidth == 2")
}

page.drawPath { context in
    context.dashStyle = DashStyle(pattern: [3], phase: 1)!
    drawLine(in: context, x: 60, y: 680, label: "dashStyle.pattern == [3], dashStyle.phase == 1 | 2 on, 3 off, 3 on...")
    
    context.dashStyle = DashStyle(pattern: [3, 7], phase: 2)!
    drawLine(in: context, x: 60, y: 650, label: "dashStyle.pattern == [7, 3], dashStyle.phase == 2 | 5 on 3 off, 7 on,...")
    
    context.dashStyle = DashStyle(pattern: [8, 7, 2, 7])!
    drawLine(in: context, x: 60, y: 620, label: "dashStyle.pattern == [8, 7, 2, 7], dashStyle.phase == 0")
}

page.drawPath { context in
    
    context.lineWidth = 30
    context.strokeColor = #colorLiteral(red: 0, green: 0.4980392157, blue: 0, alpha: 1)
    
    context.lineCap = .butt
    drawLine2(in: context, x: 60, y: 570, label: "LineCap.butt")
    
    context.lineCap = .round
    drawLine2(in: context, x: 60, y: 505, label: "LineCap.round")
    
    context.lineCap = .projectingSquare
    drawLine2(in: context, x: 60, y: 440, label: "LineCap.projectingSquare")
}

page.drawPath { context in
    
    context.lineWidth = 30
    context.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0.4980392157, alpha: 1)
    
    context.lineJoin = .miter
    context.move(toX: 120, y: 300)
    context.line(toX: 160, y: 340)
    context.line(toX: 200, y: 300)
    context.strokePath()
    
    context.lineJoin = .round
    context.move(toX: 120, y: 195)
    context.line(toX: 160, y: 235)
    context.line(toX: 200, y: 195)
    context.strokePath()
    
    context.lineJoin = .bevel
    context.move(toX: 120, y: 90)
    context.line(toX: 160, y: 130)
    context.line(toX: 200, y: 90)
    context.strokePath()
}

page.drawPath { context in
    context.lineWidth = 2
    context.strokeColor = .black
    context.fillColor = #colorLiteral(red: 0.7529411765, green: 0, blue: 0, alpha: 1)
    
    drawRect(in: context, x: 300, y: 770, label: "Stroke")
    context.strokePath()
    
    drawRect(in: context, x: 300, y: 720, label: "Fill")
    context.fillPath()
    
    drawRect(in: context, x: 300, y: 670, label: "Fill and Stroke")
    context.fillPath(stroke: true)
    
    drawRect(in: context, x: 300, y: 620, label: "Clip Rectangle")
    context.strokePath()
}

page.drawPath { context in
    
    var point = Point(x: 330, y: 440)
    var point1 = Point(x: 430, y: 530)
    var point2 = Point(x: 480, y: 470)
    let point3 = Point(x: 480, y: 90)
    
    context.dashStyle = DashStyle(pattern: [3])!
    context.lineWidth = 0.5
    
    context.move(to: point1)
    context.line(to: point2)
    context.strokePath()
    
    context.dashStyle = .straightLine
    context.lineWidth = 1.5
    
    context.move(to: point)
    context.curve(controlPoint2: point1, endPoint: point2)
    context.strokePath()
    
    point = point + Vector(x: 0, y: -150)
    point1 = point1 + Vector(x: 0, y: -150)
    point2 = point2 + Vector(x: 0, y: -150)
    
    context.dashStyle = DashStyle(pattern: [3])!
    context.lineWidth = 0.5
    
    context.move(to: point)
    context.line(to: point1)
    context.strokePath()
    
    context.dashStyle = .straightLine
    context.lineWidth = 1.5
    
    context.move(to: point)
    context.curve(controlPoint1: point1, endPoint: point2)
    context.strokePath()
    
    point = point + Vector(x: 0, y: -150)
    point1 = point1 + Vector(x: 0, y: -160)
    point2 = point2 + Vector(x: 10, y: -130)
    
    context.dashStyle = DashStyle(pattern: [3])!
    context.lineWidth = 0.5
    
    context.move(to: point)
    context.line(to: point1)
    context.move(to: point2)
    context.line(to: point3)
    context.strokePath()
    
    context.dashStyle = .straightLine
    context.lineWidth = 1.5
    context.move(to: point)
    context.curve(controlPoint1: point1, controlPoint2: point2, endPoint: point3)
    context.strokePath()
}

document.display()
