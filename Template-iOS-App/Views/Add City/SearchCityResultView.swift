
import UIKit
import MapKit


protocol SearchCityResultViewDelegate {
    func selectedCity(cityName: String)
}

class SearchCityResultView: UIView {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var cities: [MKLocalSearchCompletion]?
    
    var delegate: SearchCityResultViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: SearchCityResultCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: SearchCityResultCell.reusableIdentifier)
    }

    
    func setCities(cities: [MKLocalSearchCompletion]?) {
        self.cities = cities
        self.tableView.reloadData()
    }
}

extension SearchCityResultView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCityResultCell = tableView.dequeueReusableCell(withIdentifier: SearchCityResultCell.reusableIdentifier, for: indexPath) as! SearchCityResultCell
        
        let cityName = self.cities![indexPath.row].title
        cell.setCityName(cityName: cityName)
        
        return cell
    }
}

extension SearchCityResultView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCity(cityName: self.cities![indexPath.row].title)
    }
}
