
import Foundation

public class NetworkService {
    
    static func load(_ resource: NetworkResource, result: @escaping ((NetworkResult<Data>) -> Void)) {
        
        guard Reachability.currentReachabilityStatus != .notReachable else {
            result(.failure(APIClientError.noInternet))
            return
        }
        
        let request = URLRequest(resource)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {
                    result(.failure(APIClientError.noData))
                    return
                }
            
                if let error = error {
                    result(.failure(error))
                    return
                }
            
                result(.success(data))
            }
        }
        task.resume()
    }
}
