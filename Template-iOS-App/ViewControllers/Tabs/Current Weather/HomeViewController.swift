
import UIKit
import CoreLocation

open class HomeViewController: ControllersSliderViewController {
    
    @IBOutlet fileprivate weak var loadingView: LoadingView!
    @IBOutlet fileprivate weak var emptyDataView: EmptyDataView!
    fileprivate var previousSavedCities: [City]! = [City]()
    fileprivate var savedCities: [City]! = [City]()
    fileprivate var currentCity: City?

    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavBar()
        
        self.preloadsViewControllers = true
        
        self.emptyDataView.delegate = self
        self.view.bringSubviewToFront(self.emptyDataView)
        self.emptyDataView.hide()
        self.emptyDataView.messageLabel.text = "HOME_ALERT_MESSAGE_NO_DATA".localized
        self.view.bringSubviewToFront(self.loadingView)
        self.loadingView.show()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.runWeatherUpdating()
    }
    
    
    fileprivate func runWeatherUpdating() {
        if self.currentCity == nil {
            if LocationManager.shared.hasDeniedOrRestrictedAuthorization() {
                self.updateWeatherViews()
            } else {
                LocationManager.shared.addDelegate(self)
                LocationManager.shared.startUpdatingLocation()
            }
        } else {
            self.updateWeatherViews()
        }
    }
    
    
    fileprivate func updateWeatherViews(forced: Bool = false) {
        DispatchQueue.main.async {
            self.loadSavedCities()
            
            self.emptyDataView.hide()
            self.loadingView.hide()
            
            if self.currentCity == nil && self.savedCities.isEmpty {
                self.emptyDataView.show()
                return
            }
            
            let internetIsReachable = Reachability.isReachable
            if (self.currentCity != nil || !self.savedCities.isEmpty) && !internetIsReachable {
                self.emptyDataView.show()
                return
            }
            
            if !forced && self.savedCities == self.previousSavedCities {
                return
            }
            
            self.removeAllControllers()
            
            
            if let currentCity = self.currentCity {
                self.createController(for: currentCity)
            }
            
            for savedCity in self.savedCities {
                self.createController(for: savedCity)
            }
            
            self.updateControllers()
        }
    }

    
    fileprivate func loadSavedCities() {
        self.previousSavedCities = self.savedCities
        self.savedCities = City.getSavedCities()
    }
    
    fileprivate func createController(for city: City) {
        let cityWeatherViewController: CityWeatherViewController = UIViewController.viewController("CityWeatherViewController", storyboardName: "Home") as! CityWeatherViewController
        
        self.addController(controller: cityWeatherViewController)
        cityWeatherViewController.setCity(city: city)
    }
}


extension HomeViewController: LocationManagerDelegate {
    
    public func locationManager(_ manager: LocationManager, location: CLLocation) {
        LocationManager.shared.removeDelegate(self)
        
        LocationManager.shared.getPlace(for: location) { (placemark) in
            if let placemark = placemark {
                let currentCity = City(name: placemark.administrativeArea ?? "", location: location)
                self.currentCity = currentCity
                
                self.updateWeatherViews(forced: true)
            } else {
                self.updateWeatherViews()
            }
        }
    }
    
    public func locationManager(_ manager: LocationManager, error: NSError) {
        UIViewController.showAlert(message: error.localizedDescription)
        self.updateWeatherViews(forced: true)
    }
    
    public func locationManagerDeniedPermissions(_ manager: LocationManager) {
        self.updateWeatherViews(forced: true)
    }
}

extension HomeViewController: EmptyDataViewDelegate {
    func refreshAction() {
        self.loadingView.show()
        self.emptyDataView.hide()
        self.runWeatherUpdating()
    }
}
