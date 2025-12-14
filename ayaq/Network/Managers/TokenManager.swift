import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    private let tokenKey = "auth_jwt_token"
    private let userIdKey = "auth_user_id"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        
        if let userId = extractUserIdFromToken(token) {
            UserDefaults.standard.set(userId, forKey: userIdKey)
        }
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
    
    func hasToken() -> Bool {
        return getToken() != nil
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
    
    private func extractUserIdFromToken(_ token: String) -> String? {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        var base64String = segments[1]
        let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
        let paddingLength = requiredLength - base64String.count
        if paddingLength > 0 {
            base64String += String(repeating: "=", count: paddingLength)
        }
        
        guard let data = Data(base64Encoded: base64String),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let userId = json["sub"] as? String ?? json["nameid"] as? String ?? json["userId"] as? String else {
            return nil
        }
        
        return userId
    }
}
