/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UniformTypeIdentifiers

extension URL {
    
    public var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    public var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    public var isAlias: Bool {
        (try? resourceValues(forKeys: [.isAliasFileKey]))?.isAliasFile == true
    }
    
    public var utType: UTType?{
        UTType(filenameExtension: self.pathExtension)
    }

}
