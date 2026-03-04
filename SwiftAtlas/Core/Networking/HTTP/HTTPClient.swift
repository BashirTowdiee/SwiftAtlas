import Foundation

protocol HTTPClient: Sendable {
    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response
}
