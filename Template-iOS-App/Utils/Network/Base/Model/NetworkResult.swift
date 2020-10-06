
import Foundation

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
}

enum APIClientError: Error {
    case noData
    case noInternet
}
