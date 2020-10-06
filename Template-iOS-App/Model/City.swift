
import Foundation
import CoreLocation

struct City: Codable {
    var name: String!
    fileprivate var latitude: Double!
    fileprivate var longitude: Double!

    var location: CLLocation {
        set {
            self.latitude = newValue.coordinate.latitude
            self.longitude = newValue.coordinate.longitude
        }
        get {
            return CLLocation(latitude: self.latitude, longitude: self.longitude)
        }
        
    }
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
    
    
    func encoded() -> Data? {
        if let encoded = try? JSONEncoder().encode(self) {
            return encoded
        }
        
        return nil
    }
    
    static func decoded(from data: Data) -> City? {
        let city = try? JSONDecoder().decode(City.self, from: data)
        return city
    }
}

extension City: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}


// MARK: - Persistence

extension City {
    
    static func getSavedCities() -> [City] {
        if let savedCitiesData = UserDefaults.standard.data(forKey: Constants.USER_DEFAULTS.CITIES_KEY),
            let savedCities = try? JSONDecoder().decode([City].self, from: savedCitiesData) {

            return savedCities
        }
        
        return []
    }
    
    static func saveCities(cities: [City]) {
        if let encodedSavedCities = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.setValue(encodedSavedCities, forKey: Constants.USER_DEFAULTS.CITIES_KEY)
            UserDefaults.standard.synchronize()
        }
    }
}
