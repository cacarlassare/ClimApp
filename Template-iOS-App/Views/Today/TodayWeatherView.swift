
import UIKit

class TodayWeatherView: RoundedView {

    @IBOutlet weak var palceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    func setCurrent(current: Current, cityName: String) {
        self.palceLabel.text = cityName
        let date = Date(timeIntervalSince1970: TimeInterval((current.dt)))
        self.dateLabel.text = date.fullDateFormat()
        self.temperatureLabel.text = "\(current.temp.roundedCelsius)°C"
        self.weatherLabel.text = current.weather[0].weatherDescription.capitalized
        self.weatherIcon.image = UIImage(named: current.weather[0].icon)
    }

}
