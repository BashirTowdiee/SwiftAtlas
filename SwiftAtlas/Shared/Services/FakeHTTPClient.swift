import Foundation

final class FakeHTTPClient: HTTPClient, Sendable {
    private let payloads: [String: Data]

    init(payloads: [String: Data]) {
        self.payloads = payloads
    }

    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response {
        let key = request.path + request.queryItems.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
        guard let data = payloads[key] ?? payloads[request.path] else {
            throw AppError.network("No fake payload was registered for \(request.path).")
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
