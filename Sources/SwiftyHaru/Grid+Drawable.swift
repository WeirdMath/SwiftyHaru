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
        
        let _lineWidth = context.lineWidth
        let _strokeColor = context.strokeColor
        let _lineCap = context.lineCap
        
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
        
        //        _drawTopLabels(context: context, initialPoint: position)
        //        _drawBottomLabels(context: context, initialPoint: position)
        //        _drawLeftLabels(context: context, initialPoint: position)
        //        _drawRightLabels(context: context, initialPoint: position)
        
        // Return to the initial state
        context.lineWidth = _lineWidth
        context.strokeColor = _strokeColor
        context.lineCap = _lineCap
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
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: stride) {
            
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
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: stride) {
            
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
        
        for y in _strideVertically(initialPoint: initialPoint, by: stride) {
            
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
        
        for y in _strideVertically(initialPoint: initialPoint, by: stride) {
            
            path.move(toX: rightmostX + _horizontalLineLengthCorrection, y: y)
            path.appendLine(toX: rightmostX - right.length, y: y)
        }
        
        context.stroke(path)
    }
    
    // MARK: - Draw labels
    
    private func _drawTopLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let top = labels.top else { return }
        
        Unimplemented()
    }
    
    private func _drawBottomLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let bottom = labels.bottom else { return }
        
        Unimplemented()
    }
    
    private func _drawLeftLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let left = labels.left else { return }
        
        Unimplemented()
    }
    
    private func _drawRightLabels(context: DrawingContext, initialPoint: Point) {
        
        guard let right = labels.right else { return }
        
        Unimplemented()
    }

}
