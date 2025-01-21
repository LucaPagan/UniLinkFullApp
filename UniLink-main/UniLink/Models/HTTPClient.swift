import Foundation

let apiHostname = "https://541d-143-225-56-163.ngrok-free.app/api/v1"

enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError(Error)
    case invalidResponse
    case invalidURL
    case httpError(Int)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString(
                "Unable to perform request", comment: "badRequestError")
        case .serverError(let errorMessage):
            return NSLocalizedString(errorMessage, comment: "serverError")
        case .decodingError:
            return NSLocalizedString(
                "Unable to decode successfully.", comment: "decodingError")
        case .invalidResponse:
            return NSLocalizedString(
                "Invalid response", comment: "invalidResponse")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "invalidURL")
        case .httpError(_):
            return NSLocalizedString("Bad request", comment: "badRequest")
        }
    }
}

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    case put(Data?)

    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .put:
            return "PUT"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var modelType: T.Type
}

struct HTTPClient {
    static let shared = HTTPClient()
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json"
        ]
        self.session = URLSession(configuration: configuration)
    }

    func load<T: Codable>(_ resource: Resource<T>, loggedIn: Bool = false)
        async throws -> T
    {
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.method.name

        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(
                url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            request = URLRequest(url: url)
            if loggedIn {
                guard
                    let token = UserDefaults.standard.object(
                        forKey: "StudentToken") as? String
                else {
                    throw NetworkError.httpError(401)
                }
                request.addValue(
                    "Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        case .post(let data):
            request.httpBody = data
            if loggedIn {
                guard
                    let token = UserDefaults.standard.object(
                        forKey: "StudentToken") as? String
                else {
                    throw NetworkError.httpError(401)
                }
                request.addValue(
                    "Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        case .delete:
            break
        case .put(let data):
            request.httpBody = data
            if loggedIn {
                guard
                    let token = UserDefaults.standard.object(
                        forKey: "StudentToken") as? String
                else {
                    throw NetworkError.httpError(401)
                }
                request.addValue(
                    "Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()

            // Date formatter setup
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            let result = try decoder.decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

extension URL {
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(
                url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems
        else {
            return nil
        }

        var parameters = [String: String]()
        queryItems.forEach { item in
            parameters[item.name] = item.value
        }

        return parameters
    }
}
