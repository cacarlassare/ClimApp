
import Foundation

extension URLRequest {
    
    init(_ resource: NetworkResource) {
        self.init(url: resource.url)
        self.httpMethod = resource.method
    }
}
