import Foundation

struct APIRequest<Response: Decodable>: Sendable {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]

    init(path: String, method: HTTPMethod = .get, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
    }
}
