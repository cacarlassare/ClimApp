
import UIKit

class NextDaysWeatherView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    var dailies: [Daily]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib.init(nibName: NextDaysWeatherCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: NextDaysWeatherCell.reusableIdentifier)
    }
    
    func setDaily(dailies: [Daily]) {
        self.dailies = dailies
        self.dailies?.removeFirst()
        self.tableView.reloadData()
    }

}


extension NextDaysWeatherView: UITableViewDelegate {
    
}


extension NextDaysWeatherView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let daily = self.dailies![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NextDaysWeatherCell.reusableIdentifier, for: indexPath) as! NextDaysWeatherCell
        cell.setDaily(daily: daily)
           
       return cell
    }
}
