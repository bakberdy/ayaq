import Foundation

/// Manages JWT token storage and retrieval
class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    private let tokenKey = "auth_jwt_token"
    
    /// Save JWT token to storage
    /// - Parameter token: The JWT token from login response
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    /// Get stored JWT token
    /// - Returns: The token if exists, nil otherwise
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    /// Check if token exists
    /// - Returns: true if token exists, false otherwise
    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    /// Delete token (logout)
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
