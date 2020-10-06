
import CoreLocation
import UIKit


public protocol LocationManagerDelegate : NSObjectProtocol {
    func locationManager(_ manager: LocationManager, location: CLLocation)
    func locationManager(_ manager: LocationManager, error: NSError)
    func locationManagerDeniedPermissions(_ manager: LocationManager)
}


public class LocationManager: NSObject, CLLocationManagerDelegate {
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var locationDelegates: [LocationManagerDelegate] = []
    
    static let shared = LocationManager()
    
    
    fileprivate override init() {
        super.init()
        
        if self.locationManager == nil {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
        }
    }
    
    func notifyPermissionsDenied() {
        for delegate in self.locationDelegates {
            delegate.locationManagerDeniedPermissions(self)
        }
    }
    
    
    // MARK: - Add And Remove Delegates To Be Notified
    
    func addDelegate(_ delegate: LocationManagerDelegate) {
        for currentDelegate in self.locationDelegates {
            if currentDelegate.isEqual(delegate) {
                return
            }
        }
        
        self.locationDelegates.append(delegate)
    }
    
    func removeDelegate(_ delegate: LocationManagerDelegate) {
        for i in 0 ..< self.locationDelegates.count {
            let currentDelegate = self.locationDelegates[i]
            
            if currentDelegate.isEqual(delegate) {
                self.locationDelegates.remove(at: i)
                
                if self.locationDelegates.count == 0 {
                    self.stopUpdatingLocation()
                }
                
                return
            }
        }
    }
    
    
    // MARK: - Getters
    
    public var location: CLLocation? {
        return self.locationManager.location
    }
    
    
    // MARK: - Update Location
    
    func startUpdatingLocation() {
        if !self.hasAuthorization() {
            self.requestAuthorization()
        } else {
            self.updateLocation()
        }
    }
    
    func requestAuthorization() {
        if !self.hasAuthorization() {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func updateLocation() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.requestLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    

    // MARK: - Check status
    
    func hasAuthorization() -> Bool {
        return self.hasAlwaysAuthorization() || self.hasWhenInUseAuthorization()
    }
    
    func hasAlwaysAuthorization() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways
    }
    
    func hasWhenInUseAuthorization() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse
    }
    
    func hasDeniedOrRestrictedAuthorization() -> Bool {
        return CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted
    }
    
    
    // MARK: - Location Manager Delegate
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.startUpdatingLocation()
            
        } else if status == .denied || status == .restricted {
            self.notifyPermissionsDenied()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = self.location {
            for delegate in self.locationDelegates {
                delegate.locationManager(self, location: location)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for delegate in self.locationDelegates {
            delegate.locationManager(self, error: error as NSError)
        }
    }
    
    
    
    // MARK: - Get City Name
    
    func getLocation(forPlaceCalled name: String,
                         completion: @escaping(CLLocation?) -> Void) {
            
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
                
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil)
                    return
                }
                    
                guard let placemark = placemarks?[0] else {
                    completion(nil)
                    return
                }
                    
                guard let location = placemark.location else {
                    completion(nil)
                    return
                }

                completion(location)
            }
        }
    }
    
    
    func getPlace(for location: CLLocation,
                      completion: @escaping (CLPlacemark?) -> Void) {
            
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
                
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(nil)
                    return
                }
                
                guard let placemark = placemarks?[0] else {
                    completion(nil)
                    return
                }
                
                completion(placemark)
            }
        }
    }
}
