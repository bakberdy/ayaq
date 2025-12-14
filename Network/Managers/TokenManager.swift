import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    private let tokenKey = "auth_jwt_token"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
