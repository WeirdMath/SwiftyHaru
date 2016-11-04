//
//  Grid.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.11.16.
//
//

/// Represents a grid that can be drawn on a PDF page.
public struct Grid: Drawable {
    
    /// Creates a new grid.
    ///
    /// - parameter size:   The size of the grid.
    /// - parameter lines:  The parameters of the vertical and horizontal major and minor lines of the grid.
    ///                     Default value is `Lines.default`.
    /// - parameter labels: The parameters of the labels for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no labels will be drawn. Default value is `Labels.default`.
    /// - parameter serifs: The parameters of the serifs for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no serifs will be drawn. Default value is `Serifs.defalut`.
    public init(size: Size, lines: Lines = .default, labels: Labels? = .default, serifs: Serifs? = .default) {
        
        self.size = size
        self.lines = lines
        
        if let labels = labels {
            self.labels = labels
        } else {
            self.labels = Labels(top: nil, bottom: nil, left: nil, right: nil)
        }
        
        if let serifs = serifs {
            self.serifs = serifs
        } else {
            self.serifs = Serifs(top: nil, bottom: nil, left: nil, right: nil)
        }
    }
    
    /// Creates a new grid.
    ///
    /// - parameter width:  The width of the grid.
    /// - parameter height: The height of the grid.
    /// - parameter lines:  The parameters of the vertical and horizontal major and minor lines of the grid.
    ///                     Default value is `Lines.default`.
    /// - parameter labels: The parameters of the labels for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no labels will be drawn. Default value is `Labels.default`.
    /// - parameter serifs: The parameters of the serifs for vertocal and horizontal lines of the grid. If
    ///                     specified `nil`, no serifs will be drawn. Default value is `Serifs.defalut`.
    public init(width: Float,
                height: Float,
                lines: Lines = .default,
                labels: Labels? = .default,
                serifs: Serifs? = .default) {
        
        self.init(size: Size(width: width, height: height), lines: lines, labels: labels, serifs: serifs)
    }
    
    // MARK: - Helper types
    
    /// Represents the properties of a grid's major lines.
    public struct MajorLineParameters {
        
        /// Default parameters, where line width is 0.5, line spacing is 10, line color is 80% gray.
        public static let `default` = MajorLineParameters()
        
        /// The width of lines.
        public var lineWidth: Float
        
        /// The spacing between lines.
        public var lineSpacing: Float
        
        /// The color of lines.
        public var lineColor: Color
        
        /// Creates a new line parameter set.
        ///
        /// - parameter lineWidth:   The width of a line. Default value is 0.5.
        /// - parameter lineSpacing: The spacing between lines. Default value is 10.
        /// - parameter lineColor:   The color of lines. Default is 80% gray.
        public init(lineWidth: Float = 0.5, lineSpacing: Float = 10, lineColor: Color = Color(gray: 0.8)!) {
            self.lineWidth = lineWidth
            self.lineSpacing = lineSpacing
            self.lineColor = lineColor
        }
    }
    
    /// Represents the properties of a grid's minor lines.
    public struct MinorLineParameters {
        
        /// Default parameters, where line width is 0.25, line color is 80% gray and the default
        /// number of minor segments per one major segment is 2.
        public static let `default` = MinorLineParameters()
        
        /// The width of lines.
        public var lineWidth: Float
        
        /// The number of minor segments per one vertical major segment.
        /// Setting this property to N means that N-1 minor lines will be drawn between
        /// two adjacent major lines. Default value is 2.
        public var minorSegmentsPerMajorSegment: Int
        
        /// The color of lines.
        public var lineColor: Color
        
        /// Creates a new line parameter set.
        ///
        /// - parameter lineWidth:                    The width of a line. Default value is 0.25
        /// - parameter minorSegmentsPerMajorSegment: The number of minor segments per one vertical major segment.
        ///                                           Defaulr value is 2.
        /// - parameter lineColor:                    The color of lines. Default is 80% gray.
        public init(lineWidth: Float = 0.25,
                    minorSegmentsPerMajorSegment: Int = 2,
                    lineColor: Color = Color(gray: 0.8)!) {
            self.lineWidth = lineWidth
            self.minorSegmentsPerMajorSegment = minorSegmentsPerMajorSegment
            self.lineColor = lineColor
        }
    }
    
    /// Encapsulates the parameters of the vertical and horizontal major and minor lines.
    public struct Lines {
        
        /// Default set, where all the major and minor line parameters are set to their `.default`.
        public static let `default` = Lines()
        
        /// The parameters of the vertical major lines of the grid.
        public var verticalMajor: MajorLineParameters
        
        /// The parameters of the horizontal major lines of the grid.
        public var horizontalMajor: MajorLineParameters
        
        /// The parameters of the vertical minor lines of the grid.
        public var verticalMinor: MinorLineParameters?
        
        /// The parameters of the horizontal minor lines of the grid.
        /// Default line width is 0.25, line color is 50% gray and the default number of minor segments
        /// per one major segment is 2.
        public var horizontalMinor: MinorLineParameters?
        
        /// Creates a new set of the line parameters for each type of the line.
        ///
        /// - parameter verticalMajor:   The parameters of the vertical major lines of the grid.
        ///                              Default line width is 0.5, line spacing is 10, line color is 80% gray.
        /// - parameter horizontalMajor: The parameters of the horizontal major lines of the grid.
        ///                              Default line width is 0.5, line spacing is 10, line color is 80% gray.
        /// - parameter verticalMinor:   The parameters of the vertical minor lines of the grid.
        ///                              If specified `nil`, no vertical minor lines will be drawn.
        ///                              Default line width is 0.25, line color is 80% gray and the default
        ///                              number of minor segments per one major segment is 2.
        /// - parameter horizontalMinor: The parameters of the horizontal minor lines of the grid.
        ///                              If specified `nil`, no horizontal minor lines will be drawn.
        ///                              Default line width is 0.25, line color is 80% gray and the default
        ///                              number of minor segments per one major segment is 2.
        public init(verticalMajor: MajorLineParameters = .default,
                    horizontalMajor: MajorLineParameters = .default,
                    verticalMinor: MinorLineParameters? = .default,
                    horizontalMinor: MinorLineParameters? = .default) {
            
            self.verticalMajor = verticalMajor
            self.horizontalMajor = horizontalMajor
            self.verticalMinor = verticalMinor
            self.horizontalMinor = horizontalMinor
        }
    }
    
    /// Represents the properties of a grid's line labels. Labels can only be placed near serifs.
    public struct LabelParameters {
        
        /// Default parameters, where the `font` is Helvetica, the size of the font is 5,
        /// the color of the labels is 50% gray the frequency is 5 and the offset is 0.
        public static let `default` = LabelParameters()
        
        /// The font of labels.
        public var font: Font
        
        /// The font size of labels.
        public var fontSize: Float
        
        /// The color of labels.
        public var fontColor: Color
        
        /// The nubmber of major lines per one label.
        public var frequency: Int
        
        /// Normally labels are placed in such a way that a major line goes through the center of a label,
        /// and the bounding box of a label touches the bound of the grid, but you can specify an offset.
        public var offset: Vector
        
        /// Creates a new label parameter set.
        ///
        /// - parameter font:       The font of labels. Default is Helvetica.
        /// - parameter fontSize:   The font size of labels. Default value is 5.
        /// - parameter fontColor:  The color of labels. Default is 50% gray.
        /// - parameter frequency:  The nubmber of major lines per one label. Default value is 5.
        /// - parameter offset:     The offset of the label. Default value is `.zero`.
        public init(font: Font = .helvetica,
                    fontSize: Float = 5,
                    fontColor: Color = Color(gray: 0.5)!,
                    frequency: Int = 5,
                    offset: Vector = .zero) {
            
            self.font = font
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.frequency = frequency
            self.offset = offset
        }
    }
    
    /// Encapsulates the parameters of the labels for vertical and horizontal lines.
    public struct Labels {
        
        /// Default set, where all the label parameters are set to their `.default`.
        public static let `default` = Labels()
        
        /// The labels for vertical lines at the top of the grid.
        public var top: LabelParameters?
        
        /// The labels for vertical lines at the bottom of the grid.
        public var bottom: LabelParameters?
        
        /// The labels for horizontal lines on the left of the grid.
        public var left: LabelParameters?
        
        /// The labels for horizontal lines on the right of the grid.
        public var right: LabelParameters?
        
        /// Creates a new set of the label parameters for each kind of labels.
        ///
        /// Each parameter's default value is `LabelParameters.default`.
        ///
        /// - parameter top:     The parameters of the labels for vertical
        ///                      lines at the top of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        /// - parameter bottom:  The parameters of the labels for vertical
        ///                      lines at the bottom of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        /// - parameter left:    The parameters of the labels for horizontal
        ///                      lines on the left of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        /// - parameter right:   The parameters of the labels for horizontal
        ///                      lines on the right of the grid. If specified `nil`, no such labels
        ///                      will be drawn.
        public init(top: LabelParameters? = .default,
                    bottom: LabelParameters? = .default,
                    left: LabelParameters? = .default,
                    right: LabelParameters? = .default) {
            
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
    }
    
    /// Represents the properties of a grid's serifs. Serifs are short lines that can be placed on the edges of
    /// a grid and serve to put labels near them.
    public struct SerifParameters {
        
        /// Default parameters, where the frequency is 5, the width of the serifs is 0.5
        /// and the color of the serifs is 50% gray.
        public static let `default` = SerifParameters()
        
        /// The nubmber of major lines per one serif.
        public var frequency: Int
        
        /// The thickness of the serifs.
        public var width: Float
        
        /// The length of the serifs.
        public var length: Float
        
        /// The color of the serifs.
        public var color: Color
        
        /// Creates a new serif parameter set.
        ///
        /// - parameter frequency: The nubmber of major lines per one serif. Default value is 5.
        /// - parameter width:     The width of the serifs. Default value is 0.5.
        /// - parameter length:    The length of the serifs. Default value is 5.
        /// - parameter color:     The color of the serifs. Default is 50% gray.
        public init(frequency: Int = 5,
                    width: Float = 0.5,
                    length: Float = 5,
                    color: Color = Color(gray: 0.5)!) {
            
            self.frequency = frequency
            self.width = width
            self.length = length
            self.color = color
        }
    }
    
    public struct Serifs {
        
        /// Default set, where all the serif parameters are set to their `.default`.
        public static let `default` = Serifs()
        
        /// The serifs for vertical lines at the top of the grid.
        public var top: SerifParameters?
        
        /// The serifs for vertical lines at the bottom of the grid.
        public var bottom: SerifParameters?
        
        /// The serifs for horizontal lines on the left of the grid.
        public var left: SerifParameters?
        
        /// The serifs for horizontal lines on the right of the grid.
        public var right: SerifParameters?
        
        /// Creates a new set of the serif parameters for each kind of serifs.
        ///
        /// Each parameter's default value is `SerifParameters.default`.
        ///
        /// - parameter top:     The parameters of the serifs for vertical
        ///                      lines at the top of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        /// - parameter bottom:  The parameters of the serifs for vertical
        ///                      lines at the bottom of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        /// - parameter left:    The parameters of the serifs for horizontal
        ///                      lines on the left of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        /// - parameter right:   The parameters of the serifs for horizontal
        ///                      lines on the right of the grid. If specified `nil`, no such serifs
        ///                      will be drawn.
        public init(top: SerifParameters? = .default,
                    bottom: SerifParameters? = .default,
                    left: SerifParameters? = .default,
                    right: SerifParameters? = .default) {
            
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
    }
    
    // MARK: - Grid parameters
    
    /// The size of the grid.
    public var size: Size
    
    /// The parameters of the lines of the grid.
    public var lines: Lines
    
    /// The parameters of the labels of the grid.
    public var labels: Labels
    
    /// The parameters of the serifs of the grid.
    public var serifs: Serifs
    
    // MARK: - Drawable
    
    /// Draws the grid in the provided context.
    ///
    /// - parameter context:  The context to draw the grid in.
    /// - parameter position: The lower-left corner of the grid.
    public func draw(in context: DrawingContext, position: Point) {
        
        let _lineWidth = context.lineWidth
        let _strokeColor = context.strokeColor
        let _lineCap = context.lineCap
        
        context.lineCap = .projectingSquare
        
        _drawVerticalMinorLines(context: context, initialPoint: position)
        _drawHorizontalMinorLines(context: context, initialPoint: position)
        _drawVerticalMajorLines(context: context, initialPoint: position)
        _drawHorizontalMajorLines(context: context, initialPoint: position)
        
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
    
    private func _drawVerticalMajorLines(context: DrawingContext, initialPoint: Point) {
        
        context.strokeColor = lines.verticalMajor.lineColor
        context.lineWidth = lines.verticalMajor.lineWidth
        
        var path = Path()
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: lines.verticalMajor.lineSpacing) {
            
            path.move(toX: x, y: initialPoint.y)
            path.appendLine(toX: x, y: initialPoint.y + size.height)
        }
        
        context.stroke(path)
    }
    
    private func _drawHorizontalMajorLines(context: DrawingContext, initialPoint: Point) {
        
        context.strokeColor = lines.horizontalMajor.lineColor
        context.lineWidth = lines.horizontalMajor.lineWidth
        
        var path = Path()
        
        for y in _strideVertically(initialPoint: initialPoint, by: lines.horizontalMajor.lineSpacing) {
            
            path.move(toX: initialPoint.x, y: y)
            path.appendLine(toX: initialPoint.x + size.width, y: y)
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
            
            path.move(toX: x, y: initialPoint.y)
            path.appendLine(toX: x, y: initialPoint.y + size.height)
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
            
            path.move(toX: initialPoint.x, y: y)
            path.appendLine(toX: initialPoint.x + size.width, y: y)
        }
        
        context.stroke(path)
    }
    
    // MARK: - Draw serifs
    
    private func _drawTopSerifs(context: DrawingContext, initialPoint: Point) {
        
        guard let top = serifs.top else { return }
        
        context.strokeColor = top.color
        context.lineWidth = top.width
        
        var path = Path()
        
        let stride = Float(top.frequency) * lines.verticalMajor.lineSpacing
        
        let topY = initialPoint.y + size.height
        
        for x in _strideHorizontally(initialPoint: initialPoint, by: stride) {
            
            path.move(toX: x, y: topY)
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
            
            path.move(toX: x, y: initialPoint.y)
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
            
            path.move(toX: initialPoint.x, y: y)
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
            
            path.move(toX: rightmostX, y: y)
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

extension Grid.MajorLineParameters: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.MajorLineParameters, rhs: Grid.MajorLineParameters) -> Bool {
        return lhs.lineColor == rhs.lineColor &&
            lhs.lineSpacing == rhs.lineSpacing &&
            lhs.lineWidth == rhs.lineWidth
    }
}

extension Grid.MinorLineParameters: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.MinorLineParameters, rhs: Grid.MinorLineParameters) -> Bool {
        return lhs.lineColor == rhs.lineColor &&
            lhs.minorSegmentsPerMajorSegment == rhs.minorSegmentsPerMajorSegment &&
            lhs.lineWidth == rhs.lineWidth
    }
}

extension Grid.Lines: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.Lines, rhs: Grid.Lines) -> Bool {
        return lhs.horizontalMajor == rhs.horizontalMajor &&
            lhs.horizontalMinor == rhs.horizontalMinor &&
            lhs.verticalMajor == rhs.verticalMajor &&
            lhs.verticalMinor == rhs.verticalMinor
    }
}

extension Grid.LabelParameters: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.LabelParameters, rhs: Grid.LabelParameters) -> Bool {
        return lhs.font == rhs.font &&
            lhs.fontColor == rhs.fontColor &&
            lhs.fontSize == rhs.fontSize &&
            lhs.frequency == rhs.frequency &&
            lhs.offset == rhs.offset
    }
}

extension Grid.Labels: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.Labels, rhs: Grid.Labels) -> Bool {
        return lhs.left == rhs.left &&
            lhs.right == rhs.right &&
            lhs.top == rhs.top &&
            lhs.bottom == rhs.bottom
    }
}

extension Grid.SerifParameters: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.SerifParameters, rhs: Grid.SerifParameters) -> Bool {
        return lhs.frequency == rhs.frequency &&
            lhs.color == rhs.color &&
            lhs.width == rhs.width &&
            lhs.length == rhs.length
    }
}

extension Grid.Serifs: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid.Serifs, rhs: Grid.Serifs) -> Bool {
        return lhs.left == rhs.left &&
            lhs.right == rhs.right &&
            lhs.top == rhs.top &&
            lhs.bottom == rhs.bottom
    }
}

extension Grid: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Grid, rhs: Grid) -> Bool {
        return lhs.size == rhs.size &&
            lhs.lines == rhs.lines &&
            lhs.labels == lhs.labels &&
            lhs.serifs == rhs.serifs
    }
}
