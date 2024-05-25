/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

public struct GenericError: Error {
    
    public var text: String
    
    public init(_ text: String){
        self.text = text
    }
    
    public var errorDescription: String? {
        return text.localize()
    }
    
}
