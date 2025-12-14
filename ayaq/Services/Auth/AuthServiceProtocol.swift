import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> String
    func register(model: RegisterModel) async throws
    func requestPasswordReset(model: RequestPasswordResetModel) async throws
    func resetPassword(model: ResetPasswordModel) async throws
    func changePassword(model: ChangePasswordModel) async throws
    func changeEmail(model: ChangeEmailModel) async throws
    func getCurrentUserId() async throws -> String
    func getCurrentUserName() async throws -> String
    func logout()
}
