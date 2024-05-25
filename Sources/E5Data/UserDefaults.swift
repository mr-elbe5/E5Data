/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension UserDefaults{
    
    public func save(forKey key: String, value: Codable) {
        let storeString = value.toJSON()
        set(storeString, forKey: key)
    }
    
    public func load<T : Codable>(forKey key: String) -> T? {
        if let storedString = value(forKey: key) as? String {
            return T.fromJSON(encoded: storedString)
        }
        return nil
    }
    
    public func remove(forKey key: String){
        removeObject(forKey: key)
    }
    
}
