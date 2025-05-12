
import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingError(Error)
    case unknown
}
