
import UIKit
import CoreLocation

class WeatherService {
    
    fileprivate static let API_KEY = "30a5215e12d89952d8150108fcaf42e6"
    
    static func getWeather(for location: CLLocation, onSuccess: @escaping (WeatherResult) -> Void, onError: @escaping (Error) -> Void) {
    
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let url = URL(string: "\(Constants.URL.GET_WEATHER)?lat=\(latitude)&lon=\(longitude)&lang=\(device.languageID)&appid=\(WeatherService.API_KEY)")!
        let resource = NetworkResource(url: url)
        
        NetworkService.load(resource) { (result) in
            
            switch result {
            case .success(let data):
                
            do {
                let decoder = JSONDecoder()
                let parsedWeather = try decoder.decode(WeatherResult.self, from: data)
                
                onSuccess(parsedWeather)
            } catch let error {
                onError(error)
            }
            
            case .failure(let error):
                
                if let apiError = error as? APIClientError {
                    
                    switch apiError {
                    case .noData:
                        UIViewController.showAlert(message: "API_ERROR_ALERT_MESSAGE_NO_DATA".localized)
                    case .noInternet:
                        UIViewController.showAlert(message: "API_ERROR_ALERT_MESSAGE_NO_INTERNET_CONNECTION".localized)
                    }
                } else {
                    UIViewController.showAlert(message: error.localizedDescription)
                }
                
                onError(error)
            }
        }
    }
}
