/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */


import Foundation

extension Array{
    
    public  mutating func remove<T : Equatable>(obj : T){
        for i in 0..<count{
            if obj == self[i] as? T{
                remove(at: i)
                return
            }
        }
    }
    
    public func getTypedArray<T>(type: T.Type) -> Array<T>{
        var arr = Array<T>()
        for data in self{
            if let obj = data as? T {
                arr.append(obj)
            }
        }
        return arr
    }
    
    public func containsEqual(_ obj: IdObject) -> Bool{
        self.contains(where: {
            ($0 as? IdObject)?.equals(obj) ?? false
        })
    }
    
    public var allSelected: Bool{
        get{
            allSatisfy({
                ($0 as? Selectable)?.selected ?? false
            })
        }
    }
    
    public var allUnselected: Bool{
        get{
            allSatisfy({
                !(($0 as? Selectable)?.selected ?? false)
            })
        }
    }
    
    public mutating func selectAll(){
        for item in self{
            (item as? Selectable)?.selected = true
        }
    }
    
    public mutating func deselectAll(){
        for item in self{
            (item as? Selectable)?.selected = false
        }
    }
    
}

