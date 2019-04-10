import Foundation
import QuartzCore

public class Benchmark {
    
    public static func measureBlock(closure: () -> Void) -> CFTimeInterval {
        let runCount = 10
        var executionTimes = Array<Double>(repeating: 0.0, count: runCount)
        
        for i in 0..<runCount {
            let startTime = CACurrentMediaTime()
            closure()
            let endTime = CACurrentMediaTime()
            
            let executionTime = endTime - startTime
            executionTimes[i] = executionTime
        }
        
        return (executionTimes.reduce(0, +)) / Double(runCount)
    }
    
    public static func measureBlock(closure: () -> Void) -> TimeInterval {
        let runCount = 10
        var executionTimes = Array<Double>(repeating: 0.0, count: runCount)
        
        for i in 0..<runCount {
            let startTime = Date().timeIntervalSince1970
            closure()
            let endTime = Date().timeIntervalSince1970
            
            let executionTime = endTime - startTime
            executionTimes[i] = executionTime
        }
        
        return (executionTimes.reduce(0, +)) / Double(runCount)
    }
    
}

public extension CFTimeInterval {
    
    public var formattedTime: String {
        return self >= 1000 ? String(Int(self)) + "s"
            : self >= 1 ? String(format: "%.3gs", self)
            : self >= 1e-3 ? String(format: "%.3gms", self * 1e3)
            : self >= 1e-6 ? String(format: "%.3gµs", self * 1e6)
            : self < 1e-9 ? "0s"
            : String(format: "%.3gns", self * 1e9)
    }
    
}

public extension TimeInterval {
    
    public var formattedTime: String {
        return self >= 1000 ? String(Int(self)) + "s"
            : self >= 1 ? String(format: "%.3gs", self)
            : self >= 1e-3 ? String(format: "%.3gms", self * 1e3)
            : self >= 1e-6 ? String(format: "%.3gµs", self * 1e6)
            : self < 1e-9 ? "0s"
            : String(format: "%.3gns", self * 1e9)
    }
    
}
