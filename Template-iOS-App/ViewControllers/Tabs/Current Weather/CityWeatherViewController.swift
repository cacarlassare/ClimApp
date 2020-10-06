
import UIKit
import CoreLocation

open class CityWeatherViewController: UIViewController {
    
    @IBOutlet weak var todayView: TodayWeatherView!
    @IBOutlet weak var nextDaysView: NextDaysWeatherView!
    @IBOutlet weak var loadingView: LoadingView!
    fileprivate var city: City!
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavBar()
        
        self.updateWeather()
    }

    func updateWeather() {
        self.loadingView.show()
        self.getWeather(for: self.city.location)
    }
    
    func setCity(city: City) {
        self.city = city
    }
    
    fileprivate func getWeather(for location: CLLocation) {
        WeatherService.getWeather(for: location) { (weather) in
            self.setWeather(weather: weather)
            self.loadingView.hide()
        } onError: { (error) in
            self.loadingView.hide()
        }
    }
    
    fileprivate func setWeather(weather: WeatherResult) {
        self.todayView.setCurrent(current: weather.current, cityName: self.city.name)
        self.nextDaysView.setDaily(dailies: weather.daily)
    }
}


