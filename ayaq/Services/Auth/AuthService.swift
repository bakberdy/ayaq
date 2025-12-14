import Foundation

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClient
    private let tokenManager: TokenManager
    
    init(apiClient: APIClient = .shared, tokenManager: TokenManager = .shared) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
    }
    
    func login(email: String, password: String) async throws -> AuthToken {
        let loginModel = LoginModel(email: email, password: password)
        
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.login(loginModel), expecting: TokenDTO.self) { [weak self] result in
                guard let self = self else {
                    continuation.resume(throwing: APIError.unknownError)
                    return
                }
                
                switch result {
                case .success(let tokenDTO):
                    let authToken = AuthToken(from: tokenDTO)
                    self.tokenManager.saveToken(authToken.token)
                    continuation.resume(returning: authToken)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func register(model: RegisterModel) async throws -> AuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.register(model), expecting: TokenDTO.self) { [weak self] result in
                guard let self = self else {
                    continuation.resume(throwing: APIError.unknownError)
                    return
                }
                
                switch result {
                case .success(let tokenDTO):
                    let authToken = AuthToken(from: tokenDTO)
                    self.tokenManager.saveToken(authToken.token)
                    continuation.resume(returning: authToken)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func authenticateAnonymous() async throws -> AuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.authenticateAnonymousUser, expecting: TokenDTO.self) { [weak self] result in
                guard let self = self else {
                    continuation.resume(throwing: APIError.unknownError)
                    return
                }
                
                switch result {
                case .success(let tokenDTO):
                    let authToken = AuthToken(from: tokenDTO)
                    self.tokenManager.saveToken(authToken.token)
                    continuation.resume(returning: authToken)
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
    
    func changeEmail(model: ChangeEmailModel) async throws -> AuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.changeEmail(model), expecting: TokenDTO.self) { [weak self] result in
                guard let self = self else {
                    continuation.resume(throwing: APIError.unknownError)
                    return
                }
                
                switch result {
                case .success(let tokenDTO):
                    let authToken = AuthToken(from: tokenDTO)
                    self.tokenManager.saveToken(authToken.token)
                    continuation.resume(returning: authToken)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getCurrentUserId() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCurrentUserId, expecting: CurrentUserIdDTO.self) { result in
                switch result {
                case .success(let dto):
                    continuation.resume(returning: dto.userId ?? "")
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getCurrentUserName() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getCurrentUserName, expecting: CurrentUserNameDTO.self) { result in
                switch result {
                case .success(let dto):
                    continuation.resume(returning: dto.userName ?? "")
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func getPayload(token: String) async throws -> JwtPayload {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getPayload(token), expecting: JwtPayloadDTO.self) { result in
                switch result {
                case .success(let dto):
                    let payload = JwtPayload(from: dto)
                    continuation.resume(returning: payload)
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
