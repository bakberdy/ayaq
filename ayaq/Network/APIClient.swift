import Foundation
import os.log

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func request(_ endpoint: APIEndpoint) async throws
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let authInterceptor: AuthenticationInterceptor
    private let logger: Logger
    
    init(
        session: URLSession = .shared,
        authInterceptor: AuthenticationInterceptor
    ) {
        var config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        
        self.session = URLSession(configuration: config)
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
        self.authInterceptor = authInterceptor
        self.logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.ayaq", category: "APIClient")
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let request = try buildRequest(from: endpoint)
        logRequest(request)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Invalid HTTP response")
            throw APIError.unknownError
        }
        
        logResponse(httpResponse, data: data)
        
        try validateResponse(httpResponse, data: data)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
        }
    }
    
    func request(_ endpoint: APIEndpoint) async throws {
        let request = try buildRequest(from: endpoint)
        logRequest(request)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Invalid HTTP response")
            throw APIError.unknownError
        }
        
        logResponse(httpResponse, data: data)
        try validateResponse(httpResponse, data: data)
    }
    
    private func buildRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        let urlString = endpoint.baseURL + endpoint.path
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        authInterceptor.intercept(&request)
        
        if let body = endpoint.body {
            request.httpBody = try encoder.encode(body)
        }
        
        return request
    }
    
    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
            
        case 400...499:
            if let errorMessage = String(data: data, encoding: .utf8), !errorMessage.isEmpty {
                throw APIError.customError(errorMessage)
            }
            
            switch response.statusCode {
            case 401:
                throw APIError.unauthorized
            case 403:
                throw APIError.forbidden
            case 404:
                throw APIError.notFound
            default:
                throw APIError.requestFailed(statusCode: response.statusCode)
            }
            
        case 500...:
            throw APIError.serverError
            
        default:
            throw APIError.requestFailed(statusCode: response.statusCode)
        }
    }
    
    private func logRequest(_ request: URLRequest) {
        logger.debug("→ \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        
        if let headers = request.allHTTPHeaderFields {
            logger.debug("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            logger.debug("Body: \(bodyString)")
        }
    }
    
    private func logResponse(_ response: HTTPURLResponse, data: Data) {
        logger.debug("← \(response.statusCode) \(response.url?.absoluteString ?? "")")
        
        if let responseString = String(data: data, encoding: .utf8) {
            logger.debug("Response: \(responseString)")
        }
    }
}
