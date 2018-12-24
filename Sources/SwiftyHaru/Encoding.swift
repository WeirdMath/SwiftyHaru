//
//  Encoding.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 20.10.16.
//
//

public struct Encoding: Hashable {
    
    // MARK: - Singlebyte encodings
    
    /// It is the default encoding of PDF (*StandardEncoding*)
    public static let standard = Encoding(name: "StandardEncoding")
    
    /// The standard encoding of Mac OS (*MacRomanEncoding*)
    public static let macRoman = Encoding(name: "MacRomanEncoding")
    
    /// The standard encoding of Windows (*WinAnsiEncoding*)
    public static let windowsANSI = Encoding(name: "WinAnsiEncoding")
    
    /// Use the built-in encoding of a font (*FontSpecific*)
    public static let fontSpecific = Encoding(name: "FontSpecific")
    
    /// Latin Alphabet No.2 (*ISO8859-2*)
    public static let latinAlphabet2 = Encoding(name: "ISO8859-2")
    
    /// Latin Alphabet No.3 (*ISO8859-3*)
    public static let latinAlphabet3 = Encoding(name: "ISO8859-3")
    
    /// Latin Alphabet No.4 (*ISO8859-4*)
    public static let latinAlphabet4 = Encoding(name: "ISO8859-4")
    
    /// Latin Cyrillic Alphabet (*ISO8859-5*)
    public static let latinCyrillicAlphabet = Encoding(name: "ISO8859-5")
    
    /// Latin Arabic Alphabet (*ISO8859-6*)
    public static let latinArabicAlphabet = Encoding(name: "ISO8859-6")
    
    /// Latin Greek Alphabet (*ISO8859-7*)
    public static let latinGreekAlphabet = Encoding(name: "ISO8859-7")
    
    /// Latin Hebrew Alphabet (*ISO8859-8*)
    public static let latinHebrewAlphabet = Encoding(name: "ISO8859-8")
    
    /// Latin Alphabet No.5 (*ISO8859-9*)
    public static let latinAlphabet5 = Encoding(name: "ISO8859-9")
    
    /// Latin Alphabet No.6 (*ISO8859-10*)
    public static let latinAlphabet6 = Encoding(name: "ISO8859-10")
    
    /// Thai, TIS 620-2569 character set (*ISO8859-11*)
    public static let thai = Encoding(name: "ISO8859-11")
    
    /// Latin Alphabet No.7 (*ISO8859-13*)
    public static let latinAlphabet7 = Encoding(name: "ISO8859-13")
    
    /// Latin Alphabet No.8 (*ISO8859-14*)
    public static let latinAlphabet8 = Encoding(name: "ISO8859-14")
    
    /// Latin Alphabet No.9 (*ISO8859-15*)
    public static let latinAlphabet9 = Encoding(name: "ISO8859-15")
    
    /// Latin Alphabet No.10 (*ISO8859-16*)
    public static let latinAlphabet10 = Encoding(name: "ISO8859-16")
    
    /// Microsoft Windows Codepage 1250 (EE) (*CP1250*)
    public static let cp1250 = Encoding(name: "CP1250")
    
    /// Microsoft Windows Codepage 1251 (Cyrl) (*CP1251*)
    public static let cp1251 = Encoding(name: "CP1251")
    
    /// Microsoft Windows Codepage 1252 (ANSI) (*CP1252*)
    public static let cp1252 = Encoding(name: "CP1252")
    
    /// Microsoft Windows Codepage 1253 (Greek) (*CP1253*)
    public static let cp1253 = Encoding(name: "CP1253")
    
    /// Microsoft Windows Codepage 1254 (Turk) (*CP1254*)
    public static let cp1254 = Encoding(name: "CP1254")
    
    /// Microsoft Windows Codepage 1255 (Hebr) (*CP1255*)
    public static let cp1255 = Encoding(name: "CP1255")
    
    /// Microsoft Windows Codepage 1256 (Arab) (*CP1256*)
    public static let cp1256 = Encoding(name: "CP1256")
    
    /// Microsoft Windows Codepage 1257 (BaltRim) (*CP1257*)
    public static let cp1257 = Encoding(name: "CP1257")
    
    /// Microsoft Windows Codepage 1258 (Viet) (*CP1258*)
    public static let cp1258 = Encoding(name: "CP1258")
    
    /// Russian Net Character Set (*KOI8-R*)
    public static let koi8r = Encoding(name: "KOI8-R")
    
    // - MARK: Multibyte encodings
    
    /// EUC-CN encoding (*GB-EUC-H*)
    public static let gbEucCnHorisontal = Encoding(name: "GB-EUC-H", isMultibyte: true)
    
    /// Vertical writing version of `eucCNHorisontal` (*GB-EUC-V*)
    public static let gbEucCnVertical = Encoding(name: "GB-EUC-V", isMultibyte: true)
    
    /// Microsoft Code Page 936 (lfCharSet 0x86) GBK encoding (*GBK-EUC-H*)
    public static let gbkEucHorisontal = Encoding(name: "GBK-EUC-H", isMultibyte: true)
    
    /// Vertical writing version of `gbkEucHorisontal` (*GBK-EUC-V*)
    public static let gbkEucVertical = Encoding(name: "GBK-EUC-V", isMultibyte: true)
    
    /// Microsoft Code Page 950 (lfCharSet 0x88) Big Five character set with ETen extensions (*ETen-B5-H*)
    public static let eTenB5Horisontal = Encoding(name: "ETen-B5-H", isMultibyte: true)
    
    /// Vertical writing version of `eTenB5Horisontal` (*ETen-B5-V*)
    public static let eTenB5Vertical = Encoding(name: "ETen-B5-V", isMultibyte: true)
    
    /// Microsoft Code Page 932, JIS X 0208 character (*90ms-RKSJ-H*)
    public static let rksjHorisontal = Encoding(name: "90ms-RKSJ-H", isMultibyte: true)
    
    /// Vertical writing version of `rksjHorisontal` (*90ms-RKSJ-V*)
    public static let rksjVertical = Encoding(name: "90ms-RKSJ-V", isMultibyte: true)
    
    /// Microsoft Code Page 932, JIS X 0208 character (proportional) (*90msp-RKSJ-H*)
    public static let rksjHorisontalProportional = Encoding(name: "90msp-RKSJ-H", isMultibyte: true)
    
    /// JIS X 0208 character set, EUC-JP encoding (*EUC-H*)
    public static let eucHorisontal = Encoding(name: "EUC-H", isMultibyte: true)
    
    /// Vertical writing version of `eucHorisontal` (*EUC-V*)
    public static let eucVertical = Encoding(name: "EUC-V", isMultibyte: true)
    
    /// KS X 1001:1992 character set, EUC-KR encoding (*KSC-EUC-H*)
    public static let kscEucHorisontal = Encoding(name: "KSC-EUC-H", isMultibyte: true)
    
    /// Vertical writing version of `kscEucHorisontal` (*KSC-EUC-V*)
    public static let kscEucVertical = Encoding(name: "KSC-EUC-V", isMultibyte: true)
    
    /// Microsoft Code Page 949 (lfCharSet 0x81), KS X 1001:1992 character set plus 8822 additional hangul,
    /// Unified Hangul Code (UHC) encoding (proportional)  (*KSCms-UHC-H*)
    public static let kscMsUhcProportional = Encoding(name: "KSCms-UHC-H", isMultibyte: true)
    
    /// Microsoft Code Page 949 (lfCharSet 0x81), KS X 1001:1992 character set plus 8822 additional hangul,
    /// Unified Hangul Code (UHC) encoding (fixed width) (*KSCms-UHC-HW-H*)
    public static let kscMsUhsHorisontalFixedWidth = Encoding(name: "KSCms-UHC-HW-H", isMultibyte: true)
    
    /// Vertical writing version of `kscMsUhsHorisontalFixedWidth` (*KSCms-UHC-HW-V*)
    public static let kscMsUhsVerticalFixedWidth = Encoding(name: "KSCms-UHC-HW-V", isMultibyte: true)
    
    /// Unicode (*UTF-8*)
    public static let utf8 = Encoding(name: "UTF-8", isMultibyte: true)

    public static let builtinSingleByteEncodings: [Encoding] = [
        .standard,
        .macRoman,
        .windowsANSI,
        .latinAlphabet2,
        .latinAlphabet3,
        .latinAlphabet4,
        .latinCyrillicAlphabet,
        .latinArabicAlphabet,
        .latinGreekAlphabet,
        .latinHebrewAlphabet,
        .latinAlphabet5,
        .latinAlphabet6,
        .thai,
        .latinAlphabet7,
        .latinAlphabet8,
        .latinAlphabet9,
        .latinAlphabet10,
        .cp1250,
        .cp1251,
        .cp1252,
        .cp1253,
        .cp1254,
        .cp1255,
        .cp1256,
        .cp1257,
        .cp1258,
        .koi8r
    ]

    public static let builtinMultibyteEncodings: [Encoding] = [
        .gbEucCnHorisontal,
        .gbEucCnVertical,
        .gbkEucHorisontal,
        .gbkEucVertical,
        .eTenB5Horisontal,
        .eTenB5Vertical,
        .rksjHorisontal,
        .rksjVertical,
        .rksjHorisontalProportional,
        .eucHorisontal,
        .eucVertical,
        .kscEucHorisontal,
        .kscEucVertical,
        .kscMsUhcProportional,
        .kscMsUhsHorisontalFixedWidth,
        .kscMsUhsVerticalFixedWidth,
        .utf8
    ]

    /// `builtinSingleByteEncodings` and `builtinMultibyteEncodings` combined.
    public static let builtinEncodings: [Encoding] = builtinSingleByteEncodings + builtinMultibyteEncodings
    
    // MARK: - Interface
    
    internal let _name: String
    
    internal init(name: String, isMultibyte: Bool = false) {
        _name = name
    }
    
    /// The name of the encoding
    public var name: String {
        return _name
    }
}
