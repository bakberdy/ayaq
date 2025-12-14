import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let authInterceptor: AuthenticationInterceptor
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        
        self.session = URLSession(configuration: config)
        self.authInterceptor = AuthenticationInterceptor()
    }
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        expecting: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let urlString = endpoint.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        authInterceptor.intercept(&request)
        
        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }
        
        print("\n========== API REQUEST ==========")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        print("Headers:")
        request.allHTTPHeaderFields?.forEach { key, value in
            print("  \(key): \(value)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("================================\n")
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("\n========== API ERROR ==========")
                print("URL: \(request.url?.absoluteString ?? "N/A")")
                print("Error: \(error.localizedDescription)")
                print("==============================\n")
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("\n========== API ERROR ==========")
                print("URL: \(request.url?.absoluteString ?? "N/A")")
                print("Error: Invalid HTTP response")
                print("==============================\n")
                completion(.failure(.unknownError))
                return
            }
            
            print("\n========== API RESPONSE ==========")
            print("URL: \(request.url?.absoluteString ?? "N/A")")
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers:")
            httpResponse.allHeaderFields.forEach { key, value in
                print("  \(key): \(value)")
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
            print("==================================\n")
            
            switch httpResponse.statusCode {
            case 200...299:
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
                    print("\n========== DECODING ERROR ==========")
                    print("URL: \(request.url?.absoluteString ?? "N/A")")
                    print("Error: \(error.localizedDescription)")
                    print("====================================\n")
                    completion(.failure(.decodingError(error)))
                }
                
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
        
        print("\n========== API REQUEST ==========")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        print("Headers:")
        request.allHTTPHeaderFields?.forEach { key, value in
            print("  \(key): \(value)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("================================\n")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\n========== API ERROR ==========")
                print("URL: \(request.url?.absoluteString ?? "N/A")")
                print("Error: \(error.localizedDescription)")
                print("==============================\n")
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("\n========== API ERROR ==========")
                print("URL: \(request.url?.absoluteString ?? "N/A")")
                print("Error: Invalid HTTP response")
                print("==============================\n")
                completion(.failure(.unknownError))
                return
            }
            
            print("\n========== API RESPONSE ==========")
            print("URL: \(request.url?.absoluteString ?? "N/A")")
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers:")
            httpResponse.allHeaderFields.forEach { key, value in
                print("  \(key): \(value)")
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
            print("==================================\n")
            
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
