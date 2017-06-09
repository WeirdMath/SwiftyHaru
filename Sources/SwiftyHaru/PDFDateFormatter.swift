//
//  PDFDateFormatter.swift
//  SwiftyHaru
//
//  Created by Sergej Jaskiewicz on 04.06.2017.
//
//

import Foundation

public final class PDFDateFormatter : Formatter {

    private lazy var _dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(secondsFromGMT: 0)!
        df.dateFormat = "'D':yyyyMMddHHmmss"
        return df
    }()

    // MARK: Formatter

    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func string(for obj: Any?) -> String? {
        return (obj as? Date).flatMap { string(from: $0) }
    }

    public func string(from date: Date, timeZone: TimeZone = .current) -> String {

        let timeZoneOffset = timeZone.secondsFromGMT()

        let dateString = _dateFormatter.string(from: date + TimeInterval(timeZoneOffset))

        return dateString + _string(fromTimezoneOffset: timeZoneOffset)
    }

    public func date(from string: String) -> Date? {

        let components = string.components(separatedBy: CharacterSet(charactersIn: "Z+- "))

        guard string.characters.count >= 2 else { return nil }

        let dateString = components[0]

        let distance = dateString.characters.distance(from: dateString.startIndex, to: dateString.endIndex)
        let ind = String(string.characters[string.characters.index(string.startIndex, offsetBy: distance)])

        let timezoneString = ind + components[1]

        guard let timeZoneOffset = _timeZoneOffset(from: timezoneString) else { return nil }

        return _dateFormatter
            .date(from: dateString)?
            .addingTimeInterval(TimeInterval(-timeZoneOffset))
    }

    private func _timeZoneOffset(from string: String) -> Int? {

        guard let ind = string.characters.first else { return nil }

        let sign: Int
        switch ind {
        case "+":
            sign = 1
        case "-":
            sign = -1
        case "Z":
            return 0
        default:
            return nil
        }

        let timeZoneComponents = string
            .substring(from: string.index(after: string.startIndex))
            .components(separatedBy: "'")
        
        guard timeZoneComponents.count >= 2,
            let timezoneHour = Int(timeZoneComponents[0]),
            let timezoneMinute = Int(timeZoneComponents[1]) else { return nil }
        
        return sign * (timezoneHour * 3600 + timezoneMinute * 60)
    }

    private func _string(fromTimezoneOffset offset: Int) -> String {

        let sign: String

        if offset == 0 {
            return "Z"
        } else if offset < 0 {
            sign = "-"
        } else {
            sign = "+"
        }

        let hours = (abs(offset) / 3600) % 100
        let minutes = ((abs(offset) % 3600) / 60) % 100

        let formatted = String(format: "%02d\'%02d\'", hours, minutes)

        return "\(sign)\(formatted)"
    }
}
