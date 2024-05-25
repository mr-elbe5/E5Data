/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

public class Log{
    
    private static func log(_ str: String){
        print(str)
    }

    public static func debug(_ msg: String){
        log("debug: \(msg)")
    }

    public static func info(_ msg: String){
        log("info: \(msg)")
    }

    public static func warn(_ msg: String){
        log("warn: \(msg)")
    }

    public static func error(_ msg: String){
        log("error: \(msg)")
    }

    public static func error(_ msg: String, error: Error){
        log("error: \(msg): \(error.localizedDescription)")
    }

    public static func error(error: Error){
        log("error: \(error.localizedDescription)")
    }

    public static func error(msg: String, error: Error){
        log("error: \(msg): \(error.localizedDescription)")
    }
    
}
