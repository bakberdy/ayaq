import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> AuthToken
    func register(model: RegisterModel) async throws -> AuthToken
    func authenticateAnonymous() async throws -> AuthToken
    func requestPasswordReset(model: RequestPasswordResetModel) async throws
    func resetPassword(model: ResetPasswordModel) async throws
    func changePassword(model: ChangePasswordModel) async throws
    func changeEmail(model: ChangeEmailModel) async throws -> AuthToken
    func getCurrentUserId() async throws -> String
    func getCurrentUserName() async throws -> String
    func getPayload(token: String) async throws -> JwtPayload
    func logout()
}
