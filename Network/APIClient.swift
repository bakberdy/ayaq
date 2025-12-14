import Foundation

/// Main HTTP client that makes all network requests
class APIClient {
    static let shared = APIClient()
    
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let authInterceptor: AuthenticationInterceptor
    
    private init() {
        // Configure URLSession
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30      // Wait max 30 sec per request
        config.timeoutIntervalForResource = 60     // Wait max 60 sec total
        config.waitsForConnectivity = true         // Wait if connection drops
        
        self.session = URLSession(configuration: config)
        self.authInterceptor = AuthenticationInterceptor()
    }
    
    // MARK: - Generic Request (Returns Decoded Model)
    
    /// Make HTTP request and decode response to model
    /// - Parameters:
    ///   - endpoint: APIEndpoint (which endpoint to call)
    ///   - expecting: Type to decode response into (e.g., CatalogItemDTO.self)
    ///   - completion: Called with success/failure result
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        expecting: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        // Step 1: Build URL
        let urlString = endpoint.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Step 2: Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Step 3: Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Step 4: Apply interceptor (adds token if exists)
        authInterceptor.intercept(&request)
        
        // Step 5: Encode body if exists
        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }
        
        // Step 6: Make the HTTP request
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            // Step 7: Handle network error
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            // Step 8: Get HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            // Step 9: Handle HTTP status code
            switch httpResponse.statusCode {
            case 200...299:
                // Success! Decode response
                guard let data = data else {
                    completion(.failure(.unknownError))
                    return
                }
                
                do {
                    let decoded = try self?.decoder.decode(T.self, from: data)
                    if let decoded = decoded {
                        completion(.success(decoded))
                    } else {
                        completion(.failure(.unknownError))
                    }
                } catch {
                    completion(.failure(.decodingError(error)))
                }
                
            case 401:
                // Unauthorized - need login
                completion(.failure(.unauthorized))
                
            case 403:
                // Forbidden - no permission
                completion(.failure(.forbidden))
                
            case 404:
                // Not found
                completion(.failure(.notFound))
                
            case 500...:
                // Server error
                completion(.failure(.serverError))
                
            default:
                // Other error
                completion(.failure(.requestFailed(statusCode: httpResponse.statusCode)))
            }
        }
        
        // Step 10: Start the request
        task.resume()
    }
    
    // MARK: - Void Request (No Response Body)
    
    /// Make HTTP request that returns nothing
    /// Used for: DELETE, logout, confirm order, etc.
    /// - Parameters:
    ///   - endpoint: APIEndpoint to call
    ///   - completion: Called with success/failure result
    func request(
        _ endpoint: APIEndpoint,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        let urlString = endpoint.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        authInterceptor.intercept(&request)
        
        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }
        
        let task = session.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                completion(.success(()))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            case 500...:
                completion(.failure(.serverError))
            default:
                completion(.failure(.requestFailed(statusCode: httpResponse.statusCode)))
            }
        }
        
        task.resume()
    }
}
