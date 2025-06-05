import Foundation

/// Protocol defining network operations
protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint, method: HTTPMethod, body: Data?) async throws -> T
}

/// Network service implementation using Swift concurrency
final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable>(endpoint: APIEndpoint, method: HTTPMethod = .get, body: Data? = nil) async throws -> T {
        guard let url = makeURL(for: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Add default headers
        NetworkConfig.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            // Check for successful status code
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.unknown(error)
        }
    }
    
    private func makeURL(for endpoint: APIEndpoint) -> URL? {
        guard var urlComponents = URLComponents(string: NetworkConfig.baseURL) else {
            return nil
        }
        
        urlComponents.path = urlComponents.path.appending(endpoint.path)
        urlComponents.queryItems = endpoint.queryItems
        
        return urlComponents.url
    }
} 