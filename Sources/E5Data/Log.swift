/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

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
    
    public static var logLevel: LogLevel = .error
    
    private static func log(_ str: String){
        print(str)
        if useCache{
            cache.append(str)
        }
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
