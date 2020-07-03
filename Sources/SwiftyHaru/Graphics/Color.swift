//
//  Color.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.10.16.
//
//

import CLibHaru

/// This structure represents a color. Property values must be between 0 and 1.
///
/// Supported color spaces:
/// * `PDFColorSpace.deviceRGB`
/// * `PDFColorSpace.deviceCMYK`
/// * `PDFColorSpace.deviceGray`
public struct Color: Hashable {
    
    /// Returns the red color in `PDFColorSpace.deviceRGB` space
    public static let red = Color(red: 1, green: 0, blue: 0)!
    /// Returns the green color in `PDFColorSpace.deviceRGB` space
    public static let green = Color(red: 0, green: 1, blue: 0)!
    
    /// Returns the blue color in `PDFColorSpace.deviceRGB` space
    public static let blue = Color(red: 0, green: 0, blue: 1)!
    
    /// Returns the black color in `PDFColorSpace.deviceGray` space
    public static let black = Color(gray: 0)!
    
    /// Returns the white color in `PDFColorSpace.deviceGray` space
    public static let white = Color(gray: 1)!
    
    /// Returns the transparent white color in `PDFColorSpace.deviceGray` space
    public static let clear = Color(gray: 1, alpha: 0)!
    
    internal enum _ColorSpaceWrapper: Hashable {
        case rgb(red: Float, green: Float, blue: Float)
        case cmyk(cyan: Float, magenta: Float, yellow: Float, black: Float)
        case gray(Float)
    }
    
    internal var _wrapped: _ColorSpaceWrapper
    
    /// The color space associated with the color.
    public var colorSpace: PDFColorSpace {
        switch _wrapped {
        case .rgb:
            return .deviceRGB
        case .cmyk:
            return .deviceCMYK
        case .gray:
            return .deviceGray
        }
    }
    
    /// The value of the alpha component associated with the color.
    public var alpha: Float = 1
    
    /// The direct value of the red component associated with the color if the `colorSpace` is `.deviceRGB`, or
    /// the computed value otherwise.
    public var red: Float {
        get {
            switch _wrapped {
            case .rgb(let color):
                return color.red
            case .cmyk(let color):
                return (1 - color.cyan) * (1 - color.black)
            case .gray(let color):
                return color
            }
        }
        set {
            switch _wrapped {
            case .rgb(let color):
                _wrapped = .rgb(red: newValue, green: color.green, blue: color.blue)
            case .cmyk:
                let newBlack = 1 - max(newValue, green, blue)
                _wrapped = .cmyk(cyan: newBlack < 1 ? (1 - newValue - newBlack) / (1 - newBlack) : 0,
                                 magenta: newBlack < 1 ? (1 - green - newBlack) / (1 - newBlack) : 0,
                                 yellow: newBlack < 1 ? (1 - blue - newBlack) / (1 - newBlack) : 0,
                                 black: newBlack)
            case .gray:
                _wrapped = .gray(newValue)
            }
        }
    }
    
    /// The direct value of the green component associated with the color if the `colorSpace` is `.deviceRGB`, or
    /// the computed value otherwise.
    public var green: Float {
        get {
            switch _wrapped {
            case .rgb(let color):
                return color.green
            case .cmyk(let color):
                return (1 - color.magenta) * (1 - color.black)
            case .gray(let color):
                return color
            }
        }
        set {
            switch _wrapped {
            case .rgb(let color):
                _wrapped = .rgb(red: color.red, green: newValue, blue: color.blue)
            case .cmyk:
                let newBlack = 1 - max(red, newValue, blue)
                _wrapped = .cmyk(cyan: newBlack < 1 ? (1 - red - newBlack) / (1 - newBlack) : 0,
                                 magenta: newBlack < 1 ? (1 - newValue - newBlack) / (1 - newBlack) : 0,
                                 yellow: newBlack < 1 ? (1 - blue - newBlack) / (1 - newBlack) : 0,
                                 black: newBlack)
            case .gray:
                _wrapped = .gray(newValue)
            }
        }
    }
    
    /// The direct value of the blue component associated with the color if the `colorSpace` is `.deviceRGB`, or
    /// the computed value otherwise.
    public var blue: Float {
        get {
            switch _wrapped {
            case .rgb(let color):
                return color.blue
            case .cmyk(let color):
                return (1 - color.yellow) * (1 - color.black)
            case .gray(let color):
                return color
            }
        }
        set {
            switch _wrapped {
            case .rgb(let color):
                _wrapped = .rgb(red: color.red, green: color.green, blue: newValue)
            case .cmyk:
                let newBlack = 1 - max(red, green, newValue)
                _wrapped = .cmyk(cyan: newBlack < 1 ? (1 - red - newBlack) / (1 - newBlack) : 0,
                                 magenta: newBlack < 1 ? (1 - green - newBlack) / (1 - newBlack) : 0,
                                 yellow: newBlack < 1 ? (1 - newValue - newBlack) / (1 - newBlack) : 0,
                                 black: newBlack)
            case .gray:
                _wrapped = .gray(newValue)
            }
        }
    }
    
    /// The direct value of the cyan component associated with the color if the `colorSpace` is `.deviceCMYK`, or
    /// the computed value otherwise.
    public var cyan: Float {
        get {
            switch _wrapped {
            case .cmyk(let color):
                return color.cyan
            case .rgb(let color):
                return black < 1 ? (1 - color.red - black) / (1 - black) : 0
            case .gray:
                return 0
            }
        }
        set {
            switch _wrapped {
            case .cmyk(let color):
                _wrapped = .cmyk(cyan: newValue,
                                 magenta: color.magenta,
                                 yellow: color.yellow,
                                 black: color.black)
            case .rgb:
                _wrapped = .rgb(red: (1 - newValue) * (1 - black),
                                green: (1 - magenta) * (1 - black),
                                blue: (1 - yellow) * (1 - black))
            case .gray:
                return
            }
        }
    }
    
    /// The direct value of the magenta component associated with the color if the `colorSpace` is `.deviceCMYK`,
    /// or the computed value otherwise.
    public var magenta: Float {
        get {
            switch _wrapped {
            case .cmyk(let color):
                return color.magenta
            case .rgb(let color):
                return black < 1 ? (1 - color.green - black) / (1 - black) : 0
            default:
                return 0
            }
        }
        set {
            switch _wrapped {
            case .cmyk(let color):
                _wrapped = .cmyk(cyan: color.cyan,
                                 magenta: newValue,
                                 yellow: color.yellow,
                                 black: color.black)
            case .rgb:
                _wrapped = .rgb(red: (1 - cyan) * (1 - black),
                                green: (1 - newValue) * (1 - black),
                                blue: (1 - yellow) * (1 - black))
            case .gray:
                return
            }
        }
    }
    
    /// The direct value of the yellow component associated with the color if the `colorSpace` is `.deviceCMYK`, or
    /// the computed value otherwise.
    public var yellow: Float {
        get {
            switch _wrapped {
            case .cmyk(let color):
                return color.yellow
            case .rgb(let color):
                return black < 1 ? (1 - color.blue - black) / (1 - black) : 0
            default:
                return 0
            }
        }
        set {
            switch _wrapped {
            case .cmyk(let color):
                _wrapped = .cmyk(cyan: color.cyan,
                                 magenta: color.magenta,
                                 yellow: newValue,
                                 black: color.black)
                
            case .rgb:
                _wrapped = .rgb(red: (1 - cyan) * (1 - black),
                                green: (1 - magenta) * (1 - black),
                                blue: (1 - newValue) * (1 - black))
            case .gray:
                return
            }
        }
    }
    
    /// The direct value of the black component associated with the color if the `colorSpace` is `.deviceCMYK`
    /// or `.deviceGray`, or the computed value otherwise.
    public var black: Float {
        get {
            switch _wrapped {
            case .cmyk(let color):
                return color.black
            case .rgb(let color):
                return 1 - max(color.red, color.green, color.blue)
            case .gray(let color):
                return color
            }
        }
        set {
            switch _wrapped {
            case .cmyk(let color):
                _wrapped = .cmyk(cyan: color.cyan,
                                 magenta: color.magenta,
                                 yellow: color.yellow,
                                 black: newValue)
            case .rgb:
                _wrapped = .rgb(red: (1 - cyan) * (1 - newValue),
                                green: (1 - magenta) * (1 - newValue),
                                blue: (1 - yellow) * (1 - newValue))
            case .gray:
                _wrapped = .gray(newValue)
            }
        }
    }
    
    /// Creates a color with the RGB color model.
    ///
    /// For each parameter valid values are between 0 and 1.
    ///
    /// - Parameters:
    ///   - red:   The red component of the color.
    ///   - green: The green component of the color.
    ///   - blue:  The blue component of the color.
    ///   - alpha: The alpha component of the color. Default value is 1.
    ///
    /// - Returns: The color with the specified components, or `nil` if the values specified were invalid.
    public init?(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        
        guard (red >= 0 && red <= 1) &&
            (green >= 0 && green <= 1) &&
            (blue >= 0 && blue <= 1) &&
            (alpha >= 0 && alpha <= 1) else { return nil }
        
        _wrapped = .rgb(red: red, green: green, blue: blue)
        self.alpha = alpha
    }
    
    /// Creates a color with the CMYK color model.
    ///
    /// For each parameter valid values are between 0 and 1.
    ///
    /// - Parameters:
    ///   - cyan:    The cyan component of the color.
    ///   - magenta: The magenta component of the color.
    ///   - yellow:  The yellow component of the color.
    ///   - black:   The black component of the color.
    ///   - alpha:   The alpha component of the color. Default value is 1.
    ///
    /// - Returns: The color with the specified components, or `nil` if the values specified were invalid.
    public init?(cyan: Float, magenta: Float, yellow: Float, black: Float, alpha: Float = 1) {
        
        guard (cyan >= 0 && cyan <= 1) &&
            (magenta >= 0 && magenta <= 1) &&
            (yellow >= 0 && yellow <= 1) &&
            (black >= 0 && black <= 1) &&
            (alpha >= 0 && alpha <= 1) else { return nil }
        
        _wrapped = .cmyk(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
        self.alpha = alpha
    }
    
    /// Creates a color with the gray shades color model.
    ///
    /// For each parameter valid values are between 0 and 1.
    ///
    /// - Parameters:
    ///   - gray:   The gray component of the color.
    ///   - alpha: The alpha component of the color. Default value is 1.
    ///
    /// - Returns: The color with the specified components, or `nil` if the values specified were invalid.
    public init?(gray: Float, alpha: Float = 1) {
        
        guard gray >= 0 && gray <= 1 else { return nil }
        
        _wrapped = .gray(gray)
        self.alpha = alpha
    }
    
    /// Converts the color to the specified color space.
    ///
    /// Supported color spaces:
    /// * `PDFColorSpace.deviceRGB`
    /// * `PDFColorSpace.deviceCMYK`
    /// * `PDFColorSpace.deviceGray`
    ///
    /// - Parameter colorSpace: The color space to convert the color to.
    public mutating func convert(to colorSpace: PDFColorSpace) {
        switch colorSpace {
        case .deviceRGB:
            _wrapped = .rgb(red: red, green: green, blue: blue)
        case .deviceCMYK:
            _wrapped = .cmyk(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
        case .deviceGray:
            _wrapped = .gray(black)
        default:
            assertionFailure("The color space \(colorSpace) is not supported yet")
        }
    }
    
    /// Creates a new color by converting the current color to the specified color space.
    ///
    /// Supported color spaces:
    /// * `PDFColorSpace.deviceRGB`
    /// * `PDFColorSpace.deviceCMYK`
    /// * `PDFColorSpace.deviceGray`
    ///
    /// - Parameter colorSpace: The color space of the new color.
    /// - Returns: The new color with the specified color space.
    @inlinable
    public func converting(to colorSpace: PDFColorSpace) -> Color {
        var newColor = self
        newColor.convert(to: colorSpace)
        return newColor
    }
}

extension Color: CustomDebugStringConvertible {
    public var debugDescription: String {
        var result = "\(String(describing: Color.self))("
        switch _wrapped {
        case let .rgb(red, green, blue):
            result += "red: \(red), green: \(green), blue: \(blue)"
        case let .cmyk(cyan, magenta, yellow, black):
            result += "cyan: \(cyan), magenta: \(magenta), yellow: \(yellow), black: \(black)"
        case let .gray(gray):
            result += "gray: \(gray)"
        }
        result += ")"
        return result
    }
}

extension Color: _ExpressibleByColorLiteral {
    
    public init(_colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: red, green: green, blue: blue, alpha: alpha)!
    }
}

internal extension Color {
    
    internal init(_ haruRGBColor: HPDF_RGBColor) {
        self.init(red: haruRGBColor.r, green: haruRGBColor.g, blue: haruRGBColor.b)!
    }
    
    internal init(_ haruCMYKColor: HPDF_CMYKColor) {
        self.init(cyan: haruCMYKColor.c,
                  magenta: haruCMYKColor.m,
                  yellow: haruCMYKColor.y,
                  black: haruCMYKColor.k)!
    }
    
}
