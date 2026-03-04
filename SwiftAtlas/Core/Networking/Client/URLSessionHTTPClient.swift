import Foundation

final class URLSessionHTTPClient: HTTPClient, Sendable {
    private let baseURL: URL
    private let session: URLSession

    init(
        baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }

    func send<Response: Decodable>(_ request: APIRequest<Response>) async throws -> Response {
        var components = URLComponents(url: baseURL.appending(path: request.path), resolvingAgainstBaseURL: false)
        components?.queryItems = request.queryItems.isEmpty ? nil : request.queryItems

        guard let url = components?.url else {
            throw AppError.validation("The request URL could not be built for path \(request.path).")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network("No HTTP response was returned from the server.")
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw AppError.network("The server responded with status code \(httpResponse.statusCode).")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw AppError.decoding(error.localizedDescription)
        }
    }
}
