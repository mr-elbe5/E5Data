/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension Date{
    
    public static var localDate: Date{
        get{
            Date().toLocalDate()
        }
    }
    
    public func toLocalDate() -> Date{
        var secs = self.timeIntervalSince1970
        secs += Double(TimeZone.current.secondsFromGMT())
        return Date(timeIntervalSince1970: secs)
    }
    
    public func toUTCDate() -> Date{
        var secs = self.timeIntervalSince1970
        secs -= Double(TimeZone.current.secondsFromGMT())
        return Date(timeIntervalSince1970: secs)
    }
    
    public func dateString() -> String{
        DateFormatter.localizedString(from: self.toUTCDate(), dateStyle: .medium, timeStyle: .none)
    }
    
    public func simpleDateString() -> String{
            DateFormats.simpleDateFormatter.string(from: self)
        }
    
    public func dateTimeString() -> String{
        return DateFormatter.localizedString(from: self.toUTCDate(), dateStyle: .medium, timeStyle: .short)
    }
    
    public func longDateTimeString() -> String{
        return DateFormatter.localizedString(from: self.toUTCDate(), dateStyle: .medium, timeStyle: .medium)
    }
    
    public func timeString() -> String{
        return DateFormatter.localizedString(from: self.toUTCDate(), dateStyle: .none, timeStyle: .short)
    }
    
    public func startOfDay() -> Date{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal.startOfDay(for: self)
    }
    
    public func startOfMonth() -> Date{
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        let components = cal .dateComponents([.month, .year], from: self)
        return cal.date(from: components)!
    }
    
    public func timestampString() -> String{
        return DateFormats.timestampFormatter.string(from: self)
    }
    
    public func fileDate() -> String{
        return DateFormats.fileDateFormatter.string(from: self)
    }
    
    public func shortFileDate() -> String{
        return DateFormats.shortFileDateFormatter.string(from: self)
    }
    
    public func isoString() -> String{
        return DateFormats.isoFormatter.string(from: self)
    }
 
    public var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    public var exifString : String{
        DateFormats.exifDateFormatter.string(from: self)
    }

    public init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }

}

public class DateFormats{
    
    public static var timestampFormatter : DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }
    
    public static var simpleDateFormatter : DateFormatter{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .none
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }
    
    public static var fileDateFormatter : DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter
    }
    
    public static var shortFileDateFormatter : DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm"
        return dateFormatter
    }
    
    public static var isoFormatter : ISO8601DateFormatter{
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return dateFormatter
    }
    
    public static var exifDateFormatter : DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return dateFormatter
    }
    
    public static var iptcDateFormatter : DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }
    
    public static var iptcTimeFormatter : DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .none
        dateFormatter.dateFormat = "HHmmss"
        return dateFormatter
    }
    
}

