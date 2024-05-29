/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension FileManager {
    
    public static let tempURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    public static let privateURL : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    public static let documentURL : URL = FileManager.default.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    public static let imageLibraryURL : URL = FileManager.default.urls(for: .picturesDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    public static func initializePrivateDir() {
        try! FileManager.default.createDirectory(at: privateURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func fileExists(dirPath: String, fileName: String) -> Bool{
        return fileExists(atPath: dirPath.appendingPathComponent(fileName))
    }
    
    public func fileExists(url: URL) -> Bool{
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    public func isDirectory(url: URL) -> Bool{
        var isDir:ObjCBool = true
        return fileExists(atPath: url.path, isDirectory: &isDir) && isDir.boolValue
    }
    
    public func readFile(url: URL) -> Data?{
        if let fileData = contents(atPath: url.path){
            return fileData
        }
        return nil
    }
    
    public func readTextFile(url: URL) -> String?{
        do{
            let string = try String(contentsOf: url, encoding: .utf8)
            return string
        }
        catch{
            return nil
        }
    }
    
    public func readJsonFile<T : Codable>(storeKey : String, from dir: URL) -> T?{
        let url = dir.appendingPathComponent(storeKey + ".json")
        if let string = readTextFile(url: url){
            return T.fromJSON(encoded: string)
        }
        return nil
    }
    
    public func assertDirectoryFor(url: URL) -> Bool{
        let dirUrl = url.deletingLastPathComponent()
        var isDir:ObjCBool = true
        if !fileExists(atPath: dirUrl.path, isDirectory: &isDir) {
            do{
                try createDirectory(at: dirUrl, withIntermediateDirectories: true)
            }
            catch let err{
                Log.error("FileController could not create directory", error: err)
                return false
            }
        }
        return true
    }
    
    @discardableResult
    public func saveFile(data: Data, url: URL) -> Bool{
        do{
            try data.write(to: url, options: .atomic)
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    public func saveFile(text: String, url: URL) -> Bool{
        do{
            try text.write(to: url, atomically: true, encoding: .utf8)
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    public func saveJsonFile(data: Codable, storeKey : String, to dir: URL) -> Bool{
        let value = data.toJSON()
        let url = dir.appendingPathComponent(storeKey + ".json")
        return saveFile(text: value, url: url)
    }
    
    @discardableResult
    public func copyFile(name: String,fromDir: URL, toDir: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: toDir.appendingPathComponent(name)){
                _ = deleteFile(url: toDir.appendingPathComponent(name))
            }
            try copyItem(at: fromDir.appendingPathComponent(name), to: toDir.appendingPathComponent(name))
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    public func copyFile(fromURL: URL, toURL: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: toURL){
                _ = deleteFile(url: toURL)
            }
            try FileManager.default.copyItem(at: fromURL, to: toURL)
            return true
        } catch let err{
            Log.error("FileController", error: err)
            return false
        }
    }
    
    @discardableResult
    public func renameFile(dirURL: URL, fromName: String, toName: String) -> Bool{
        do{
            try moveItem(at: dirURL.appendingPathComponent(fromName),to: dirURL.appendingPathComponent(toName))
            return true
        }
        catch {
            return false
        }
    }
    
    @discardableResult
    public func deleteFile(dirURL: URL, fileName: String) -> Bool{
        do{
            try removeItem(at: dirURL.appendingPathComponent(fileName))
            return true
        }
        catch {
            return false
        }
    }
    
    @discardableResult
    public func deleteFile(url: URL) -> Bool{
        do{
            try FileManager.default.removeItem(at: url)
            return true
        }
        catch {
            return false
        }
    }
    
    public func listAllFiles(dirPath: String) -> Array<String>{
        return try! FileManager.default.contentsOfDirectory(atPath: dirPath)
    }
    
    public func listAllURLs(dirURL: URL) -> Array<URL>{
        let names = listAllFiles(dirPath: dirURL.path)
        var urls = Array<URL>()
        for name in names{
            urls.append(dirURL.appendingPathComponent(name))
        }
        return urls
    }
    
    public func deleteAllFiles(dirURL: URL) -> Int{
        let names = listAllFiles(dirPath: dirURL.path)
        var count = 0
        for name in names{
            if deleteFile(dirURL: dirURL, fileName: name){
                count += 1
            }
        }
        return count
    }
    
    public func deleteTemporaryFiles() -> Int{
        deleteAllFiles(dirURL: temporaryDirectory)
    }
    
}
