/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */


import Foundation

open class AsyncOperation : Operation{
    
    public enum State: String {
        case isReady
        case isExecuting
        case isFinished
    }
    
    public var state: State = .isReady {
        willSet(newValue) {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override public var isExecuting: Bool { state == .isExecuting }
    
    override public var isFinished: Bool {
        if isCancelled && state != .isExecuting { return true }
        return state == .isFinished
    }
    
    override public var isAsynchronous: Bool { true }
    
    override public func start() {
        guard !isCancelled else { return }
        state = .isExecuting
        startExecution()
    }
    
    open func startExecution(){
        // override this
    }
    
}
