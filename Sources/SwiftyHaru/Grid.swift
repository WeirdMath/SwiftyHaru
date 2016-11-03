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
    /// - parameter size:            The size of the grid.
    /// - parameter verticalMajor:   The parameters of the vertical major lines of the grid.
    ///                              Default line width is 0.5, line spacing is 10, line color is 50% gray.
    /// - parameter horizontalMajor: The parameters of the horizontal major lines of the grid.
    ///                              Default line width is 0.5, line spacing is 10, line color is 50% gray.
    /// - parameter verticalMinor:   The parameters of the vertical minor lines of the grid.
    ///                              If specified `nil`, no vertical minor lines will be drawn.
    ///                              Default line width is 0.25, line color is 80% gray and the default
    ///                              number of minor segments per one major segment is 2.
    /// - parameter horizontalMinor: The parameters of the horizontal minor lines of the grid.
    ///                              If specified `nil`, no horizontal minor lines will be drawn.
    ///                              Default line width is 0.25, line color is 80% gray and the default
    ///                              number of minor segments per one major segment is 2.
    public init(size: Size,
                verticalMajor: MajorLineParameters = .default,
                horizontalMajor: MajorLineParameters = .default,
                verticalMinor: MinorLineParameters? = .default,
                horizontalMinor: MinorLineParameters? = .default) {
        
        self.size = size
        self.verticalMajor = verticalMajor
        self.horizontalMajor = horizontalMajor
        self.verticalMinor = verticalMinor
        self.horizontalMinor = horizontalMinor
    }
    
    /// Creates a new grid.
    ///
    /// - parameter width:           The width of the grid.
    /// - parameter height:          The height of the grid.
    /// - parameter verticalMajor:   The parameters of the vertical major lines of the grid.
    ///                              Default line width is 0.5, line spacing is 10, line color is 50% gray.
    /// - parameter horizontalMajor: The parameters of the horizontal major lines of the grid.
    ///                              Default line width is 0.5, line spacing is 10, line color is 50% gray.
    /// - parameter verticalMinor:   The parameters of the vertical minor lines of the grid.
    ///                              If specified `nil`, no vertical minor lines will be drawn.
    ///                              Default line width is 0.25, line color is 80% gray and the default
    ///                              number of minor segments per one major segment is 2.
    /// - parameter horizontalMinor: The parameters of the horizontal minor lines of the grid.
    ///                              If specified `nil`, no horizontal minor lines will be drawn.
    ///                              Default line width is 0.25, line color is 80% gray and the default
    ///                              number of minor segments per one major segment is 2.
    public init(width: Float,
                height: Float,
                verticalMajor: MajorLineParameters = .default,
                horizontalMajor: MajorLineParameters = .default,
                verticalMinor: MinorLineParameters? = .default,
                horizontalMinor: MinorLineParameters? = .default) {
        
        self.size = Size(width: width, height: height)
        self.verticalMajor = verticalMajor
        self.horizontalMajor = horizontalMajor
        self.verticalMinor = verticalMinor
        self.horizontalMinor = horizontalMinor
    }
    
    /// Represents the properties of a grid's major lines.
    public struct MajorLineParameters {
        
        /// Default parameters, where line width is 0.5, line spacing is 10, line color is 50% gray.
        public static let `default` = MajorLineParameters(lineWidth: 0.5,
                                                          lineSpacing: 10,
                                                          lineColor: Color(gray: 0.5)!)
        
        /// The width of lines.
        public var lineWidth: Float
        
        /// The spacing between lines.
        public var lineSpacing: Float
        
        /// The color of lines.
        public var lineColor: Color
        
        /// Creates a new line parameter set.
        ///
        /// - parameter lineWidth:   The width of a line.
        /// - parameter lineSpacing: The spacing between lines.
        /// - parameter lineColor:   The color of lines.
        public init(lineWidth: Float, lineSpacing: Float, lineColor: Color) {
            self.lineWidth = lineWidth
            self.lineSpacing = lineSpacing
            self.lineColor = lineColor
        }
    }
    
    /// Represents the properties of a grid's minor lines.
    public struct MinorLineParameters {
        
        /// Default parameters, where line width is 0.25, line color is 80% gray and the default
        /// number of minor segments per one major segment is 2.
        public static let `default` = MinorLineParameters(lineWidth: 0.25,
                                                          minorSegmentsPerMajorSegment: 2,
                                                          lineColor: Color(gray: 0.8)!)
        
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
        /// - parameter lineWidth:                    The width of a line.
        /// - parameter minorSegmentsPerMajorSegment: The number of minor segments per one vertical major segment.
        /// - parameter lineColor:                    The color of lines.
        public init(lineWidth: Float, minorSegmentsPerMajorSegment: Int, lineColor: Color) {
            self.lineWidth = lineWidth
            self.minorSegmentsPerMajorSegment = minorSegmentsPerMajorSegment
            self.lineColor = lineColor
        }
    }
    
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
    
    /// The size of the grid.
    public var size: Size
    
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
        
        // Return to the initial state
        context.lineWidth = _lineWidth
        context.strokeColor = _strokeColor
        context.lineCap = _lineCap
    }
    
    private func _drawVerticalMajorLines(context: DrawingContext, initialPoint: Point) {
        
        context.strokeColor = verticalMajor.lineColor
        context.lineWidth = verticalMajor.lineWidth
        
        var path = Path()
        
        for x in stride(from: initialPoint.x,
                        through: initialPoint.x + size.width,
                        by: verticalMajor.lineSpacing) {
                            
                            path.move(toX: x, y: initialPoint.y)
                            path.appendLine(toX: x, y: initialPoint.y + size.height)
        }
        
        context.stroke(path)
    }
    
    private func _drawHorizontalMajorLines(context: DrawingContext, initialPoint: Point) {
        
        context.strokeColor = horizontalMajor.lineColor
        context.lineWidth = horizontalMajor.lineWidth
        
        var path = Path()
        
        for y in stride(from: initialPoint.y,
                        through: initialPoint.y + size.height,
                        by: horizontalMajor.lineSpacing) {
                            
                            path.move(toX: initialPoint.x, y: y)
                            path.appendLine(toX: initialPoint.x + size.width, y: y)
        }
        
        context.stroke(path)
    }
    
    private func _drawVerticalMinorLines(context: DrawingContext, initialPoint: Point) {
        
        guard let verticalMinor = verticalMinor else { return }
        
        context.strokeColor = verticalMinor.lineColor
        context.lineWidth = verticalMinor.lineWidth
        
        var path = Path()
        
        for x in stride(from: initialPoint.x,
                        through: initialPoint.x + size.width,
                        by: verticalMajor.lineSpacing / Float(verticalMinor.minorSegmentsPerMajorSegment)) {
                            
                            path.move(toX: x, y: initialPoint.y)
                            path.appendLine(toX: x, y: initialPoint.y + size.height)
        }
        
        context.stroke(path)
    }
    
    private func _drawHorizontalMinorLines(context: DrawingContext, initialPoint: Point) {
        
        guard let horizontalMinor = horizontalMinor else { return }
        
        context.strokeColor = horizontalMinor.lineColor
        context.lineWidth = horizontalMinor.lineWidth
        
        var path = Path()
        
        for y in stride(from: initialPoint.y,
                        through: initialPoint.y + size.height,
                        by: horizontalMajor.lineSpacing / Float(horizontalMinor.minorSegmentsPerMajorSegment)) {
                            
                            path.move(toX: initialPoint.x, y: y)
                            path.appendLine(toX: initialPoint.x + size.width, y: y)
        }
        
        context.stroke(path)
    }
}
