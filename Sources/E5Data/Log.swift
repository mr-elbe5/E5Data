/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

public protocol LogDelegate{
    func newLog(log: String)
}

public class Log{
    
    public enum LogLevel: Int{
        case none
        case error
        case warn
        case info
        case debug
    }
    
    public static var cache = Array<String>()
    
    public static var useCache = false
    
    public static var logLevel: LogLevel = .info
    
    public static var delegate: LogDelegate? = nil
    
    private static func log(_ str: String){
        let logStr = "\(Date().longDateTimeString())\n \(str)"
        print(logStr)
        if useCache{
            cache.append(logStr)
        }
        delegate?.newLog(log: logStr)
    }

    public static func debug(_ msg: String){
        if logLevel.rawValue >= LogLevel.debug.rawValue{
            log("debug: \(msg)")
        }
    }

    public static func info(_ msg: String){
        if logLevel.rawValue >= LogLevel.info.rawValue{
            log("info: \(msg)")
        }
    }

    public static func warn(_ msg: String){
        if logLevel.rawValue >= LogLevel.warn.rawValue{
            log("warn: \(msg)")
        }
    }

    public static func error(_ msg: String){
        if logLevel.rawValue >= LogLevel.error.rawValue{
            log("error: \(msg)")
        }
    }

    public static func error(_ msg: String, error: Error){
        if logLevel.rawValue >= LogLevel.error.rawValue{
            log("error: \(msg): \(error.localizedDescription)")
        }
    }

    public static func error(error: Error){
        if logLevel.rawValue >= LogLevel.error.rawValue{
            log("error: \(error.localizedDescription)")
        }
    }

    public static func error(msg: String, error: Error){
        if logLevel.rawValue >= LogLevel.error.rawValue{
            log("error: \(msg): \(error.localizedDescription)")
        }
    }
    
}
