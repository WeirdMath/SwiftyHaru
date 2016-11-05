//
//  Grid+Drawable.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.11.16.
//
//

extension Grid: Drawable {
    
    /// Draws the grid in the provided context.
    ///
    /// - parameter context:  The context to draw the grid in.
    /// - parameter position: The lower-left corner of the grid.
    public func draw(in context: DrawingContext, position: Point) {
        
        // Memorize the initial state
        let _lineWidth = context.lineWidth
        let _strokeColor = context.strokeColor
        let _fillColor = context.fillColor
        let _lineCap = context.lineCap
        let _font = context.font
        let _fontSize = context.fontSize
        
        if lines.drawVerticalMinorLinesFirst {
            _drawVerticalMinorLines(context: context, initialPoint: position)
            _drawHorizontalMinorLines(context: context, initialPoint: position)
        } else {
            _drawHorizontalMinorLines(context: context, initialPoint: position)
            _drawVerticalMinorLines(context: context, initialPoint: position)
        }
        
        if lines.drawVerticalMajorLinesFirst {
            _drawVerticalMajorLines(context: context, initialPoint: position)
            _drawHorizontalMajorLines(context: context, initialPoint: position)
        } else {
            _drawHorizontalMajorLines(context: context, initialPoint: position)
            _drawVerticalMajorLines(context: context, initialPoint: position)
        }
        
        _drawTopSerifs(context: context, initialPoint: position)
        _drawBottomSerifs(context: context, initialPoint: position)
        _drawLeftSerifs(context: context, initialPoint: position)
        _drawRightSerifs(context: context, initialPoint: position)
        
        _drawTopLabels(context: context, initialPoint: position)
        _drawBottomLabels(context: context, initialPoint: position)
        _drawLeftLabels(context: context, initialPoint: position)
        _drawRightLabels(context: context, initialPoint: position)
        
        // Return to the initial state
        context.lineWidth = _lineWidth
        context.strokeColor = _strokeColor
        context.fillColor = _fillColor
        context.lineCap = _lineCap
        context.font = _font
        context.fontSize = _fontSize
    }
    
    
    // MARK: - Draw lines
    
    private func _strideHorizontally(initialPoint: Point, by _stride: Float) -> StrideThrough<Float> {
        return stride(from: initialPoint.x, through: initialPoint.x + size.width, by: _stride)
    }
    
    private func _strideVertically(initialPoint: Point, by _stride: Float) -> StrideThrough<Float> {
        return stride(from: initialPoint.y, through: initialPoint.y + size.height, by: _stride)
    }
    
    private var _verticalLineLengthCorrection: Float {
        return max(lines.horizontalMajor.lineWidth, lines.horizontalMinor?.lineWidth ?? 0) / 2
    }
    
    private var _horizontalLineLengthCorrection: Float {
        return max(lines.verticalMajor.lineWidth, lines.verticalMinor?.lineWidth ?? 0) / 2
    }
    
    private func _drawVerticalMajorLines(context: DrawingContext, initialPoint: Point) {
        
        context.strokeColor = lines.verticalMajor.lineColor
        context.lineWidth = lines.verticalMajor.lineWidth
        
        var path = Path()
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: lines.verticalMajor.lineSpacing) {
            
            path.move(toX: x, y: initialPoint.y - _verticalLineLengthCorrection)
            path.appendLine(toX: x, y: initialPoint.y + size.height + _verticalLineLengthCorrection)
        }
        
        context.stroke(path)
    }
    
    private func _drawHorizontalMajorLines(context: DrawingContext, initialPoint: Point) {
        
        context.strokeColor = lines.horizontalMajor.lineColor
        context.lineWidth = lines.horizontalMajor.lineWidth
        
        var path = Path()
        
        for y in _strideVertically(initialPoint: initialPoint, by: lines.horizontalMajor.lineSpacing) {
            
            path.move(toX: initialPoint.x - _horizontalLineLengthCorrection, y: y)
            path.appendLine(toX: initialPoint.x + size.width + _horizontalLineLengthCorrection, y: y)
        }
        
        context.stroke(path)
    }
    
    private func _drawVerticalMinorLines(context: DrawingContext, initialPoint: Point) {
        
        guard let verticalMinor = lines.verticalMinor else { return }
        
        context.strokeColor = verticalMinor.lineColor
        context.lineWidth = verticalMinor.lineWidth
        
        var path = Path()
        
        let stride = lines.verticalMajor.lineSpacing / Float(verticalMinor.minorSegmentsPerMajorSegment)
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: stride) {
            
            path.move(toX: x, y: initialPoint.y - _verticalLineLengthCorrection)
            path.appendLine(toX: x, y: initialPoint.y + size.height + _verticalLineLengthCorrection)
        }
        
        context.stroke(path)
    }
    
    private func _drawHorizontalMinorLines(context: DrawingContext, initialPoint: Point) {
        
        guard let horizontalMinor = lines.horizontalMinor else { return }
        
        context.strokeColor = horizontalMinor.lineColor
        context.lineWidth = horizontalMinor.lineWidth
        
        var path = Path()
        
        let stride = lines.horizontalMajor.lineSpacing / Float(horizontalMinor.minorSegmentsPerMajorSegment)
        
        for y in _strideVertically(initialPoint: initialPoint, by: stride) {
            
            path.move(toX: initialPoint.x - _horizontalLineLengthCorrection, y: y)
            path.appendLine(toX: initialPoint.x + size.width + _horizontalLineLengthCorrection, y: y)
        }
        
        context.stroke(path)
    }
    
    // MARK: - Draw serifs
    
    private func _drawTopSerifs(context: DrawingContext, initialPoint: Point) {
        
        guard let top = serifs.top else { return }
        
        context.strokeColor = top.color
        context.lineWidth = top.width
        
        let stride = Float(top.frequency) * lines.verticalMajor.lineSpacing
        let topY = initialPoint.y + size.height
        
        var path = Path()
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: stride).dropFirst().dropLast() {
            
            path.move(toX: x, y: topY + _verticalLineLengthCorrection)
            path.appendLine(toX: x, y: topY - top.length)
        }
        
        context.stroke(path)
    }
    
    private func _drawBottomSerifs(context: DrawingContext, initialPoint: Point) {
        
        guard let bottom = serifs.bottom else { return }
        
        context.strokeColor = bottom.color
        context.lineWidth = bottom.width
        
        var path = Path()
        
        let stride = Float(bottom.frequency) * lines.verticalMajor.lineSpacing
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: stride).dropFirst().dropLast() {
            
            path.move(toX: x, y: initialPoint.y - _verticalLineLengthCorrection)
            path.appendLine(toX: x, y: initialPoint.y + bottom.length)
        }
        
        context.stroke(path)
    }
    
    private func _drawLeftSerifs(context: DrawingContext, initialPoint: Point) {
        
        guard let left = serifs.left else { return }
        
        context.strokeColor = left.color
        context.lineWidth = left.width
        
        var path = Path()
        
        let stride = Float(left.frequency) * lines.horizontalMajor.lineSpacing
        
        for y in _strideVertically(initialPoint: initialPoint, by: stride).dropFirst().dropLast() {
            
            path.move(toX: initialPoint.x - _horizontalLineLengthCorrection, y: y)
            path.appendLine(toX: initialPoint.x + left.length, y: y)
        }
        
        context.stroke(path)
    }
    
    private func _drawRightSerifs(context: DrawingContext, initialPoint: Point) {
        
        guard let right = serifs.right else { return }
        
        context.strokeColor = right.color
        context.lineWidth = right.width
        
        var path = Path()
        
        let stride = Float(right.frequency) * lines.horizontalMajor.lineSpacing
        
        let rightmostX = initialPoint.x + size.width
        
        for y in _strideVertically(initialPoint: initialPoint, by: stride).dropFirst().dropLast() {
            
            path.move(toX: rightmostX + _horizontalLineLengthCorrection, y: y)
            path.appendLine(toX: rightmostX - right.length, y: y)
        }
        
        context.stroke(path)
    }
    
    // MARK: - Draw labels
    
    private func _drawTopLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let top = labels.top else { return }
        
        context.fillColor = top.fontColor
        context.font = top.font
        context.fontSize = top.fontSize
        
        let stride = Float(top.frequency) * lines.verticalMajor.lineSpacing
        let xSequence = top.reversed ?
            _strideHorizontally(initialPoint: initialPoint, by: stride).reversed() :
            Array(_strideHorizontally(initialPoint: initialPoint, by: stride))
        let labelIterator = top.sequence.makeIterator()
        
        let ascent = context.fontAscent
        
        for x in xSequence.dropLast() {
            
            guard let text = labelIterator.next() else { break }
            
            let labelWidth = context.textWidth(for: text)
            
            let textPosition = Point(x: x - labelWidth / 2,
                                     y: initialPoint.y + size.height - ascent) + top.offset
            
            context.show(text: text, atPosition: textPosition)
        }
    }
    
    private func _drawBottomLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let bottom = labels.bottom else { return }
        
        context.fillColor = bottom.fontColor
        context.font = bottom.font
        context.fontSize = bottom.fontSize
        
        let stride = Float(bottom.frequency) * lines.verticalMajor.lineSpacing
        let xSequence = bottom.reversed ?
            _strideHorizontally(initialPoint: initialPoint, by: stride).reversed() :
            Array(_strideHorizontally(initialPoint: initialPoint, by: stride))
        let labelIterator = bottom.sequence.makeIterator()
        
        let descent = context.fontDescent
        
        for x in xSequence.dropLast() {
            
            guard let text = labelIterator.next() else { break }
            
            let labelWidth = context.textWidth(for: text)
            
            let textPosition = Point(x: x - labelWidth / 2,
                                     y: initialPoint.y - descent) + bottom.offset
            
            context.show(text: text, atPosition: textPosition)
        }
    }
    
    private func _drawLeftLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let left = labels.left else { return }
        
        context.fillColor = left.fontColor
        context.font = left.font
        context.fontSize = left.fontSize
        
        let stride = Float(left.frequency) * lines.horizontalMajor.lineSpacing
        let ySequence = left.reversed ?
            _strideVertically(initialPoint: initialPoint, by: stride).reversed() :
            Array(_strideVertically(initialPoint: initialPoint, by: stride))
        let labelIterator = left.sequence.makeIterator()
        
        let ascent = context.fontAscent
        
        for y in ySequence.dropLast() {
            
            guard let text = labelIterator.next() else { break }
            
            let bboxHeight = context.boundingBox(for: text, atPosition: .zero).height
            
            let textPosition = Point(x: initialPoint.x,
                                     y: y + bboxHeight / 2 - ascent) + left.offset
            
            context.show(text: text, atPosition: textPosition)
        }
    }
    
    private func _drawRightLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let right = labels.right else { return }
        
        context.fillColor = right.fontColor
        context.font = right.font
        context.fontSize = right.fontSize
        
        let stride = Float(right.frequency) * lines.horizontalMajor.lineSpacing
        let ySequence = right.reversed ?
            _strideVertically(initialPoint: initialPoint, by: stride).reversed() :
            Array(_strideVertically(initialPoint: initialPoint, by: stride))
        let labelIterator = right.sequence.makeIterator()
        
        let ascent = context.fontAscent
        
        for y in ySequence.dropLast() {
            
            guard let text = labelIterator.next() else { break }
            
            let bboxSize = context.boundingBox(for: text, atPosition: .zero).size
            
            let textPosition = Point(x: initialPoint.x + size.width - bboxSize.width,
                                     y: y + bboxSize.height / 2 - ascent) + right.offset
            
            context.show(text: text, atPosition: textPosition)
        }
    }

}
