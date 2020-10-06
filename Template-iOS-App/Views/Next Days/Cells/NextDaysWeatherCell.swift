
import UIKit

class NextDaysWeatherCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    static let reusableIdentifier: String = "NextDaysWeatherCell"

    func setDaily(daily: Daily) {
        let date = Date(timeIntervalSince1970: TimeInterval((daily.dt)))
        self.dateLabel.text = date.dayAndMonthFormat()
        self.temperatureLabel.text = "\(daily.temp.min.roundedCelsius)°C / \(daily.temp.max.roundedCelsius)°C"
        self.weatherIcon.image = UIImage(named: daily.weather[0].icon)
    }
}
