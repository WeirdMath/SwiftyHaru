# Change Log

## Unreleased

**Breaking changes:**

- `PDFError.pageInvalidSize` and `PDFError.pageInvalidDirection` are removed.

**Implemented features:**

- Setting text rendering mode
- Specifying a text matrix when showing text
- Setting character spacing and word spacing
- Measuring the number of characters that fit in a width
- All the enums now conform to `CaseIterable`

## [0.3.0](https://github.com/WeirdMath/SwiftyHaru/tree/0.3.0) (2018-12-24)

Please note that this version requires Swift 4.2.

**Breaking changes:**

(Those are a bit massive, sorry.)

- `PDFPage.draw(_:)` is removed. The closure for drawing can now be passed to the `PDFDocument.addPage(_:)` family of methods. This is because multiple calls of `PDFPage.draw(_:)` resulted in redundant drawing operations (when resetting the context to the default state before each call). To migrate, merge your multiple calls of `PDFPage.draw(_:)` to one call of `PDFDocument.addPage(_:)`. Pay attention that because of this the `DrawingContext.textLeading` property is initially set to 0 (not 11 like before), so you may want to change its value before doing any text operations. Also, if you need to access the `PDFPage`'s properties from the drawing closure, use the `DrawingContext.page` property.
- `PDFPage.draw(object:position:)` and `PDFPage.draw(object:x:y:)` are removed. Use the `DrawingContext.draw(_:position:)` and `DrawingContext.draw(_:x:y:)` methods instead.
- `DashStyle.pattern` and `DashStyle.phase` are now `let`, since changing those values wasn't in any way validated.
- `Vector` is now a separate type, not a typealias for `Point`. Its intefrace has slightly changed: the fields have been renamed from `x` and `y` to `dx` and `dy`. This new type includes some arithmetic operators that make its use simpler.
- The required method `draw(in:position:)` of the `Drawable` protocol is marked `throws`.
- `PDFDocument.setEncryptionMode(to:)` and `PDFDocument.setPermissions(to:)` are removed. Use the `PDFDocument.setPassword(owner:user:permissions:encryptionMode:)` method  instead.
- `DrawingContext.withNewGState(_:)` doesn't throw if its argument doesn't. Same for `DrawingContext.clip(to:rule:_:)`. If the graphics state stack depth exceeds `static DrawingContext.maxGraphicsStateDepth`, a precondition failure occures.
- `static PDFError.exceedGStateLimit` is removed.

**Implemented features:**

- `AffineTransform` struct that helps you easily apply transforms like rotation, scaling and translation to a document's coordinate system.
- Concatenating the transformation matrix of a page + convenience methods for translation, scaling and rotation.
- Getting the current transformation matrix of a page.
- Added conformance to `Hashable` for many types.
- Improved debug descriptions for `Color` and the geometric types.

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
