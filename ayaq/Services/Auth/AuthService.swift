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
            apiClient.request(.login(loginModel), expecting: TokenDTO.self) { [weak self] result in
                switch result {
                case .success(let tokenDTO):
                    let token = tokenDTO.authToken ?? ""
                    self?.tokenManager.saveToken(token)
                    continuation.resume(returning: token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func register(model: RegisterModel) async throws -> TokenDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.register(model), expecting: TokenDTO.self) { [weak self] result in
                switch result {
                case .success(let tokenDTO):
                    if let token = tokenDTO.authToken {
                        self?.tokenManager.saveToken(token)
                    }
                    continuation.resume(returning: tokenDTO)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func requestPasswordReset(model: RequestPasswordResetModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.requestPasswordReset(model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func resetPassword(model: ResetPasswordModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.resetPassword(model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func changePassword(model: ChangePasswordModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.changePassword(model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func changeEmail(model: ChangeEmailModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.changeEmail(model), expecting: TokenDTO.self) { result in
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
                continuation.resume(with: result)
            }
        }
    }
    
    func getCurrentUserName() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCurrentUserName, expecting: String.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func logout() {
        tokenManager.clearToken()
    }
}
