import Foundation

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClient
    private let tokenManager: TokenManager
    
    init(apiClient: APIClient = .shared, tokenManager: TokenManager = .shared) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
    }
    
    func login(email: String, password: String) async throws -> String {
        let loginModel = LoginModel(email: email, password: password)
        
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.login(loginModel), expecting: String.self) { [weak self] result in
                switch result {
                case .success(let token):
                    self?.tokenManager.saveToken(token)
                    continuation.resume(returning: token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func register(model: RegisterModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.register(model)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func requestPasswordReset(model: RequestPasswordResetModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.requestPasswordReset(model)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func resetPassword(model: ResetPasswordModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.resetPassword(model)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func changePassword(model: ChangePasswordModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.changePassword(model)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func changeEmail(model: ChangeEmailModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.changeEmail(model)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getCurrentUserId() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCurrentUserId, expecting: String.self) { result in
                switch result {
                case .success(let userId):
                    continuation.resume(returning: userId)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getCurrentUserName() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCurrentUserName, expecting: String.self) { result in
                switch result {
                case .success(let userName):
                    continuation.resume(returning: userName)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func logout() {
        tokenManager.clearToken()
    }
}
