
import UIKit

class SearchCityResultCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    static let reusableIdentifier: String = "SearchCityResultCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCityName(cityName: String) {
        self.cityNameLabel.text = cityName
    }
}
