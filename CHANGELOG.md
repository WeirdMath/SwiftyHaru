# Change Log

## Unreleased

Please note that this version requires Swift 4.2.

**Breaking changes:**

- `DrawingContext.withNewGState(_:)` doesn't throw if its argument doesn't. Same for `DrawingContext.clip(to:rule:_:)`. If the graphics state stack depth exceeds `static DrawingContext.maxGraphicsStateDepth`, a precondition failure occures.
- `static PDFError.exceedGStateLimit` is removed.

**Implemented features:**

- `AffineTransform` struct that helps you easily apply transforms like rotation, scaling and translation to a document's coordinate system.
- Concatenating the transformation matrix of a page + convenience methods for translation, scaling and rotation.
- Getting the current transformation matrix of a page.

## [0.2.0](https://github.com/WeirdMath/SwiftyHaru/tree/0.2.0) (2017-06-25)

Please note that this version requires Swift 3.1.

**Breaking changes:**

- Changed the signature of the `DrawingContext.fill(_:evenOddRule:stroke:)` and `DrawingContext.clip(to:evenOddRule:_:)` methods. Instead of `Bool` value for fill rule they now require the `Path.FillRule` enum value.

**Closed issues:**

- Implement high-level grid drawing [\#6](https://github.com/WeirdMath/SwiftyHaru/issues/6)
- Package has unsupported layout for linux [\#7](https://github.com/WeirdMath/SwiftyHaru/issues/7)

**Implemented features:**

- Loading TrueType fonts from a .ttc collection
- Getting a bounding box of a specified text put at a specified position
- Getting the ascent of a font
- Getting the descent of a font
- Getting the x-height of a font
- Getting the cap height of a font
- Setting metadata (author, creator, title, subject, keywords, creation date, modification date)
- Setting a password, encryption mode and permissions
- Setting a compression mode
- Getting the depth of the graphics state stack
- Closure-based syntax for saving and restoring the graphics state
- Showing a text in a provided rectangle
- **High-level customizable interface for drawing grids!**

**Fixes:**

- Setting `miterLimit`, `font` and `fontSize` of `DrawingContext`, `width` and `height` of `PDFPage` to an invalid value now causes precondition failure.

## [0.1.0](https://github.com/WeirdMath/SwiftyHaru/tree/0.1.0) (2016-11-02)
**Closed issues:**

- Add CocoaPods support [\#4](https://github.com/WeirdMath/SwiftyHaru/issues/4)

**Implemented features:**

- Creating PDF documents
- Saving a document's contents into binary `Data`
- Appending and inserting pages to documents
- Setting a page's layout
- Adding labels to pages
- Loading TrueType fonts from file
- Setting a page's size
- Rotating a page
- Measuring a width of a specified text
- Path construction
- Path painting
- Setting a font
- Setting a font size
- Setting a line width
- Setting a line cap
- Setting a line join
- Setting a miter limit
- Setting a dash style
- Setting a text leading
- Setting a stroke and fill color and color space
- Placing a text on a page
