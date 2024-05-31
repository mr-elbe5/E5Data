/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension String {
    
    public func localize() -> String{
        return NSLocalizedString(self,comment: "")
    }
    
    public func localize(table: String) -> String{
        return NSLocalizedString(self,tableName: table, comment: "")
    }
    
    public func localize(i: Int) -> String{
        return String(format: NSLocalizedString(self,comment: ""), String(i))
    }
    
    public func localize(i1: Int, i2: Int) -> String{
        return String(format: NSLocalizedString(self,comment: ""), String(i1), String(i2))
    }
    
    public func localize(param1: String, param2: String, param3: String) -> String{
        return String(format: self.localize(), param1, param2, param3)
    }
    
    public func localize(s: String) -> String{
        return String(format: NSLocalizedString(self,comment: ""), s)
    }
    
    public func localize(param: String) -> String{
        return String(format: self.localize(), param)
    }
    
    public func localize(param1: String, param2: String) -> String{
        return String(format: self.localize(), param1, param2)
    }
    
    public func localizeAsMandatory() -> String{
        return String(format: NSLocalizedString(self,comment: "")) + " *"
    }
    
    public func localizeWithColon() -> String{
        return localize() + ": "
    }
    
    public func localizeWithColonAsMandatory() -> String{
        return localize() + ":* "
    }

    public func trim() -> String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func removeTimeStringMilliseconds() -> String{
        if self.hasSuffix("Z"), let idx = self.lastIndex(of: "."){
            return self[self.startIndex ..< idx] + "Z"
        }
        return self
    }
    
    public func ISO8601Date() -> Date?{
        ISO8601DateFormatter().date(from: self.removeTimeStringMilliseconds())
    }
    
    public func toURL() -> String{
        self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
    }
    
    public func appendingPathComponent(_ pathComponent: String) -> String{
        self + "/" + pathComponent
    }
    
    func lastPathComponent() -> String{
        if var pos = lastIndex(of: "/")    {
            pos = index(after: pos)
            return String(self[pos..<endIndex])
        }
        return self
    }

    func pathExtension() -> String {
        if let idx = index(of: ".", from: startIndex) {
            return String(self[index(after: idx)..<endIndex])
        }
        return self
    }

    func pathWithoutExtension() -> String {
        if let idx = index(of: ".", from: startIndex) {
            return String(self[startIndex..<idx])
        }
        return self
    }

}
