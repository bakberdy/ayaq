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
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
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
