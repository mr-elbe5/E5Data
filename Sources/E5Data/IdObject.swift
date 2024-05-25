/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

open class IdObject : Identifiable, Codable, Selectable{
    
    public static func == (lhs: IdObject, rhs: IdObject) -> Bool {
        lhs.equals(rhs)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    public var id : Int
    public var selected = false
    
    public init(){
        id = IdProvider.shared.nextId
    }
    
    public required init(from decoder: Decoder) throws {
        let values: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
    
    public func equals(_ obj: IdObject) -> Bool{
        self.id == obj.id
    }
    
}
