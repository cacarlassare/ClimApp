
import Foundation

public typealias Temperature = Double

public extension Temperature {
    
    var celsius: Temperature {
        return self - 273.0
    }
    
    var roundedCelsius: Int {
        return Int(self.celsius)
    }
}
