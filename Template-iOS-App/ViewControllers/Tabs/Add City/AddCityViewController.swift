
import UIKit
import MapKit

class AddCityViewController: UIViewController, MKLocalSearchCompleterDelegate {

    @IBOutlet weak var searchView: SearchCityResultView!
    @IBOutlet weak var savedCitiesView: SearchCitySavedCities!
    
    fileprivate var searchCompleter: MKLocalSearchCompleter? = MKLocalSearchCompleter()
    fileprivate var savedCities: [City]! = [City]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configSearchController()
        
        self.searchView.isHidden = true
        self.searchView.delegate = self
        
        self.loadSavedCities()
    }
    
    fileprivate func configSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ADD_CITY_SEARCHBAR_PLACEHOLDER".localized
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        self.searchCompleter?.delegate = self
        self.searchCompleter?.filterType = .locationsOnly
        if #available(iOS 13.0, *) {
            self.searchCompleter?.resultTypes = .address
        }
    }
    
    fileprivate func loadSavedCities() {
        self.savedCities = City.getSavedCities()
        self.savedCitiesView.setCities(cities: self.savedCities)
    }
    
    fileprivate func saveCities() {
        City.saveCities(cities: self.savedCities)
    }
    
    fileprivate func clearSearch() {
        self.navigationItem.searchController?.searchBar.text = ""
        self.navigationItem.searchController?.isActive = false
        self.searchView.setCities(cities: nil)
    }
}


extension AddCityViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.clearSearch()
        self.searchView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchView.isHidden = false
    }
}


extension AddCityViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter?.queryFragment = searchController.searchBar.text ?? ""
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchView.setCities(cities: completer.results)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}


extension AddCityViewController: SearchCityResultViewDelegate {
    func selectedCity(cityName: String) {
        self.clearSearch()
        self.searchView.isHidden = true
        
        LocationManager.shared.getLocation(forPlaceCalled: cityName) { (location) in
            
            if let location = location {
                let city = City(name: cityName, location: location)
                
                self.savedCities.append(city)
                self.saveCities()
                
                self.savedCitiesView.setCities(cities: self.savedCities)
            }
        }
    }
}
