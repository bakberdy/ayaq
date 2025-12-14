import Foundation

/// Automatically adds JWT token to Authorization header of every request
class AuthenticationInterceptor {
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
    }
    
    /// Add JWT token to Authorization header
    /// - Parameter request: URLRequest to modify (inout means we modify it)
    func intercept(_ request: inout URLRequest) {
        // Get token from TokenManager
        guard let token = tokenManager.getToken() else {
            // No token? That's OK for some endpoints (like login)
            // Just continue without adding header
            return
        }
        
        // Add Authorization header with Bearer token
        let authHeader = "Bearer \(token)"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
    }
}
