
import Foundation

public struct Constants {
    
    // MARK: - URLs
    
    public struct URL {
        static let BASE = "https://api.openweathermap.org"

        static let GET_WEATHER = "\(Constants.URL.BASE)/data/2.5/onecall"
    }
    
    public struct USER_DEFAULTS {
        static let CITIES_KEY = "CITIES_KEY"
    }
    
}
