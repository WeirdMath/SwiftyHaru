//
//  Color.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 03.10.16.
//
//

import CLibHaru

/// This structure represents a color. Property values must be between 0 and 1.
public struct Color {
    
    // TODO: Now only RGB color model is supported. If different color model is used in Libharu, colors
    // are implicitly converted to RGB. We need to implement handling different models,
    // for example, by wrapping such an enum.
    internal enum _colorSpace {
        case rgb(red: Float, green: Float, blue: Float)
        case cmyk(cyan: Float, magenta: Float, yellow: Float, black: Float)
    }
    
    static let red = Color(red: 1, green: 0, blue: 0)!
    static let green = Color(red: 0, green: 1, blue: 0)!
    static let blue = Color(red: 0, green: 0, blue: 1)!
    static let black = Color(red: 0, green: 0, blue: 0)!
    static let white = Color(red: 1, green: 1, blue: 1)!
    static let clear = Color(red: 1, green: 1, blue: 1, alpha: 0)!
    
    public var red: Float
    public var green: Float
    public var blue: Float
    public var alpha: Float = 1
    
    public var cyan: Float {
        get {
            return black > 0 ? (1 - red - black) / (1 - black) : 0
        }
        set {
            red = (1 - newValue) * (1 - black)
            green = (1 - magenta) * (1 - black)
            blue = (1 - yellow) * (1 - black)
        }
    }
    
    public var magenta: Float {
        get {
            return black != 0 ? (1 - green - black) / (1 - black) : 0
        }
        set {
            red = (1 - cyan) * (1 - black)
            green = (1 - newValue) * (1 - black)
            blue = (1 - yellow) * (1 - black)
        }
    }
    
    public var yellow: Float {
        get {
            return black != 0 ? (1 - blue - black) / (1 - black) : 0
        }
        set {
            red = (1 - cyan) * (1 - black)
            green = (1 - magenta) * (1 - black)
            blue = (1 - newValue) * (1 - black)
        }
    }
    
    public var black: Float {
        get {
            return 1 - max(red, green, blue)
        }
        set {
            red = (1 - cyan) * (1 - newValue)
            green = (1 - magenta) * (1 - newValue)
            blue = (1 - yellow) * (1 - newValue)
        }
    }
    
    public var isGray: Bool {
        return (red == green) && (green == blue)
    }
    
    public init?(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        
        guard (red >= 0 && red <= 1) &&
            (green >= 0 && green <= 1) &&
            (blue >= 0 && blue <= 1) &&
            (alpha >= 0 && alpha <= 1) else { return nil }
        
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init?(cyan: Float, magenta: Float, yellow: Float, black: Float, alpha: Float = 1) {
        
        guard (cyan >= 0 && cyan <= 1) &&
            (magenta >= 0 && magenta <= 1) &&
            (yellow >= 0 && yellow <= 1) &&
            (black >= 0 && black <= 1) &&
            (alpha >= 0 && alpha <= 1) else { return nil }
        
        red = (1 - cyan) * (1 - black)
        green = (1 - magenta) * (1 - black)
        blue = (1 - yellow) * (1 - black)
        self.alpha = alpha
    }
    
    public init?(gray: Float, alpha: Float = 1) {
        
        guard gray >= 0 && gray <= 1 else { return nil }
        
        red = gray
        green = gray
        blue = gray
        self.alpha = alpha
    }
}

extension Color: _ExpressibleByColorLiteral {
    
    public init(colorLiteralRed: Float, green: Float, blue: Float, alpha: Float) {
        precondition(
            (colorLiteralRed >= 0 && colorLiteralRed <= 1) &&
                (green >= 0 && green <= 1) &&
                (blue >= 0 && blue <= 1) &&
                (alpha >= 0 && alpha <= 1),
            "Color components must be in range 0...1")
        
        self.red = colorLiteralRed
        self.green = green
        self.blue = blue
    }
}

internal extension Color {
    
    internal init(_ haruColor: HPDF_RGBColor) {
        self.init(red: haruColor.r, green: haruColor.g, blue: haruColor.b)!
    }
    
    internal init(_ haruColor: HPDF_CMYKColor) {
        self.init(cyan: haruColor.c, magenta: haruColor.m, yellow: haruColor.m, black: haruColor.k)!
    }
}
