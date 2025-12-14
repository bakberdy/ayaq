import Foundation

class AuthenticationInterceptor {
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager = TokenManager.shared) {
        self.tokenManager = tokenManager
    }
    
    func intercept(_ request: inout URLRequest) {
        guard let token = tokenManager.getToken() else {
            return
        }
        
        let authHeader = "Bearer \(token)"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
    }
}
