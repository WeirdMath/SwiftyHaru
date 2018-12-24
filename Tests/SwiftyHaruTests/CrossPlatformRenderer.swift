/*

 Erica Sadun, http://ericasadun.com
 Cross Platform Defines: Image Renderer

 Apple Platforms Only

 */

#if canImport(Cocoa)
import Cocoa
#elseif canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
typealias CocoaImage = NSImage
typealias CocoaColor = NSColor
#elseif canImport(UIKit)
typealias CocoaImage = UIImage
typealias CocoaColor = UIColor
#endif

#if canImport(Cocoa)
final class CocoaGraphicsImageRendererFormat: NSObject {
    public var opaque: Bool = false
    public var prefersExtendedRange: Bool = false
    public var scale: CGFloat = 2.0
    public var bounds: CGRect = .zero
}
#elseif canImport(UIKit)
typealias CocoaGraphicsImageRendererFormat = UIGraphicsImageRendererFormat
#endif

#if canImport(Cocoa)
final class CocoaGraphicsImageRendererContext: NSObject {

    var format: CocoaGraphicsImageRendererFormat

    var cgContext: CGContext {
        guard let context = NSGraphicsContext.current?.cgContext else {
            fatalError("Unavailable cgContext while drawing")
        }
        return context
    }

    func clip(to rect: CGRect) {
        cgContext.clip(to: rect)
    }

    func fill(_ rect: CGRect) {
        cgContext.fill(rect)
    }

    func fill(_ rect: CGRect, blendMode: CGBlendMode) {
        NSGraphicsContext.saveGraphicsState()
        cgContext.setBlendMode(blendMode)
        cgContext.fill(rect)
        NSGraphicsContext.restoreGraphicsState()
    }

    func stroke(_ rect: CGRect) {
        cgContext.stroke(rect)
    }

    func stroke(_ rect: CGRect, blendMode: CGBlendMode) {
        NSGraphicsContext.saveGraphicsState()
        cgContext.setBlendMode(blendMode)
        cgContext.stroke(rect)
        NSGraphicsContext.restoreGraphicsState()
    }

    override init() {
        self.format = CocoaGraphicsImageRendererFormat()
        super.init()
    }

    var currentImage: NSImage {
        guard let cgImage = cgContext.makeImage() else {
            fatalError("Cannot retrieve cgImage from current context")
        }
        return NSImage(cgImage: cgImage, size: format.bounds.size)
    }
}
#elseif canImport(UIKit)
typealias CocoaGraphicsImageRendererContext = UIGraphicsImageRendererContext
#endif

#if canImport(Cocoa)
final class CocoaGraphicsImageRenderer: NSObject {

    var allowsImageOutput: Bool = true

    let format: CocoaGraphicsImageRendererFormat

    let bounds: CGRect

    init(bounds: CGRect, format: CocoaGraphicsImageRendererFormat) {
        self.bounds = bounds
        self.format = format
        self.format.bounds = self.bounds
        super.init()
    }

    convenience init(size: CGSize, format: CocoaGraphicsImageRendererFormat) {
        self.init(bounds: CGRect(origin: .zero, size: size), format: format)
    }

    convenience init(size: CGSize) {
        self.init(bounds: CGRect(origin: .zero, size: size), format: CocoaGraphicsImageRendererFormat())
    }

    public func image(actions: @escaping (CocoaGraphicsImageRendererContext) -> Void) -> NSImage {
        let image = NSImage(size: format.bounds.size, flipped: false) { (drawRect: NSRect) -> Bool in

            let imageContext = CocoaGraphicsImageRendererContext()
            imageContext.format = self.format
            actions(imageContext)

            return true
        }
        return image
    }
}
#elseif canImport(UIKit)
typealias CocoaGraphicsImageRenderer = UIGraphicsImageRenderer
#endif
