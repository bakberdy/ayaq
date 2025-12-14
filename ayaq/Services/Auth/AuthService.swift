import Foundation

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClientProtocol
    private let tokenManager: TokenManager
    
    init(
        apiClient: APIClientProtocol,
        tokenManager: TokenManager
    ) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
    }
    
    func login(email: String, password: String) async throws -> AuthToken {
        let loginModel = LoginModel(email: email, password: password)
        let dto: TokenDTO = try await apiClient.request(.login(loginModel))
        let authToken = AuthToken(from: dto)
        tokenManager.saveToken(authToken.token)
        return authToken
    }
    
    func register(model: RegisterModel) async throws -> AuthToken {
        let dto: TokenDTO = try await apiClient.request(.register(model))
        let authToken = AuthToken(from: dto)
        tokenManager.saveToken(authToken.token)
        return authToken
    }
    
    func authenticateAnonymous() async throws -> AuthToken {
        let dto: TokenDTO = try await apiClient.request(.authenticateAnonymousUser)
        let authToken = AuthToken(from: dto)
        tokenManager.saveToken(authToken.token)
        return authToken
    }
    
    func requestPasswordReset(model: RequestPasswordResetModel) async throws {
        try await apiClient.request(.requestPasswordReset(model))
    }
    
    func resetPassword(model: ResetPasswordModel) async throws {
        try await apiClient.request(.resetPassword(model))
    }
    
    func changePassword(model: ChangePasswordModel) async throws {
        try await apiClient.request(.changePassword(model))
    }
    
    func changeEmail(model: ChangeEmailModel) async throws -> AuthToken {
        let dto: TokenDTO = try await apiClient.request(.changeEmail(model))
        let authToken = AuthToken(from: dto)
        tokenManager.saveToken(authToken.token)
        return authToken
    }
    
    func getCurrentUserId() async throws -> String {
        let dto: CurrentUserIdDTO = try await apiClient.request(.getCurrentUserId)
        return dto.userId ?? ""
    }
    
    func getCurrentUserName() async throws -> String {
        let dto: CurrentUserNameDTO = try await apiClient.request(.getCurrentUserName)
        return dto.userName ?? ""
    }
    
    func getPayload(token: String) async throws -> JwtPayload {
        let dto: JwtPayloadDTO = try await apiClient.request(.getPayload(token))
        return JwtPayload(from: dto)
    }
    
    func logout() {
        tokenManager.clearToken()
    }
}
