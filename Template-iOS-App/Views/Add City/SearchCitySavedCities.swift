
import UIKit

class SearchCitySavedCities: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var cities: [City]?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: SearchCityResultCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: SearchCityResultCell.reusableIdentifier)
    }
    
    
    func setCities(cities: [City]?) {
        self.cities = cities
        self.tableView.reloadData()
    }
}


extension SearchCitySavedCities: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCityResultCell = tableView.dequeueReusableCell(withIdentifier: SearchCityResultCell.reusableIdentifier, for: indexPath) as! SearchCityResultCell
        
        let city = self.cities![indexPath.row]
        cell.setCityName(cityName: city.name)
        
        return cell
    }
    
    
}
