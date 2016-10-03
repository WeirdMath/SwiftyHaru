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
public struct Color {
    
    /// Returns the red color in `PDFColorSpace.deviceRGB` space
    public static let red = Color(red: 1, green: 0, blue: 0)!
    /// Returns the green color in `PDFColorSpace.deviceRGB` space
    public static let green = Color(red: 0, green: 1, blue: 0)!
    
    /// Returns the blue color in `PDFColorSpace.deviceRGB` space
    public static let blue = Color(red: 0, green: 0, blue: 1)!
    
    /// Returns the black color in `PDFColorSpace.deviceRGB` space
    public static let black = Color(red: 0, green: 0, blue: 0)!
    
    /// Returns the white color in `PDFColorSpace.deviceRGB` space
    public static let white = Color(red: 1, green: 1, blue: 1)!
    
    /// Returns the transparent white color in `PDFColorSpace.deviceRGB` space
    public static let clear = Color(red: 1, green: 1, blue: 1, alpha: 0)!
    
    internal enum _ColorSpaceWrapper {
        case rgb(red: Float, green: Float, blue: Float)
        case cmyk(cyan: Float, magenta: Float, yellow: Float, black: Float)
        case gray(Float)
    }
    
    internal var _wrapped: _ColorSpaceWrapper
    
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
    
    public var alpha: Float = 1
    
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
    
    public init?(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        
        guard (red >= 0 && red <= 1) &&
            (green >= 0 && green <= 1) &&
            (blue >= 0 && blue <= 1) &&
            (alpha >= 0 && alpha <= 1) else { return nil }
        
        _wrapped = .rgb(red: red, green: green, blue: blue)
        self.alpha = alpha
    }
    
    public init?(cyan: Float, magenta: Float, yellow: Float, black: Float, alpha: Float = 1) {
        
        guard (cyan >= 0 && cyan <= 1) &&
            (magenta >= 0 && magenta <= 1) &&
            (yellow >= 0 && yellow <= 1) &&
            (black >= 0 && black <= 1) &&
            (alpha >= 0 && alpha <= 1) else { return nil }
        
        _wrapped = .cmyk(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
        self.alpha = alpha
    }
    
    public init?(gray: Float, alpha: Float = 1) {
        
        guard gray >= 0 && gray <= 1 else { return nil }
        
        _wrapped = .gray(gray)
        self.alpha = alpha
    }
    
    public mutating func convert(to colorSpace: PDFColorSpace) {
        switch colorSpace {
        case .deviceRGB:
            _wrapped = .rgb(red: red, green: green, blue: blue)
        case .deviceCMYK:
            _wrapped = .cmyk(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
        case .deviceGray:
            _wrapped = .gray(black)
        default:
            fatalError("The color space \(String(describing: colorSpace)) is not supported yet")
        }
    }
    
    public func converting(to colorSpace: PDFColorSpace) -> Color {
        var newColor = self
        newColor.convert(to: colorSpace)
        return newColor
    }
}

extension Color: _ExpressibleByColorLiteral {
    
    public init(colorLiteralRed: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: colorLiteralRed, green: green, blue: blue, alpha: alpha)!
    }
}

extension Color: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Color, rhs: Color) -> Bool {
        
        guard lhs.alpha == rhs.alpha else { return false }
        
        switch (lhs._wrapped, rhs._wrapped) {
        case (.rgb(let color1), .rgb(let color2)):
            return color1.red == color2.red &&
                color1.green == color2.green &&
                color1.blue == color2.blue
        case (.cmyk(let color1), .cmyk(let color2)):
            return color1.black == color2.black &&
                color1.cyan == color2.cyan &&
                color1.magenta == color2.magenta &&
                color1.yellow == color2.yellow
        case (.gray(let color1), .gray(let color2)):
            return color1 == color2
        default:
            return false
        }
    }
}

internal extension Color {
    
    internal init(_ haruRGBColor: HPDF_RGBColor) {
        self.init(red: haruRGBColor.r, green: haruRGBColor.g, blue: haruRGBColor.b)!
    }
    
    internal init(_ haruCMYKColor: HPDF_CMYKColor) {
        self.init(cyan: haruCMYKColor.c,
                  magenta: haruCMYKColor.m,
                  yellow: haruCMYKColor.m,
                  black: haruCMYKColor.k)!
    }
    
}
