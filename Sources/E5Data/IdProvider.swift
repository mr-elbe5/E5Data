/*
 Construction Defect Tracker
 App for tracking construction defects
 Copyright: Michael Rönnau mr@elbe5.de 2023
 */

import Foundation

open class IdProvider : Codable{
    
    public static var storeKey = "idProvider"
    
    public static var minNewId = 1000000
    
    public static var shared = IdProvider()
    
    public static func load(){
        if let data: IdProvider = FileManager.default.readJsonFile(storeKey: IdProvider.storeKey, from: FileManager.privateURL){
            shared = data
        }
        else{
            shared = IdProvider()
        }
        shared.save()
    }
    
    public func save(){
        FileManager.default.saveJsonFile(data: self, storeKey: IdProvider.storeKey, to: FileManager.privateURL)
    }
    
    enum CodingKeys: String, CodingKey {
        case lastId
    }
    
    public var lastId: Int
    
    public var nextId: Int{
        lastId += 1
        save()
        return lastId
    }
    
    public init(){
        lastId = IdProvider.minNewId
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lastId = try values.decodeIfPresent(Int.self, forKey: .lastId) ?? IdProvider.minNewId
        if lastId < IdProvider.minNewId{
            lastId = IdProvider.minNewId
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lastId, forKey: .lastId)
    }
    
}
