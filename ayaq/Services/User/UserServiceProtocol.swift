import Foundation

protocol UserServiceProtocol {
    func getAllUsers() async throws -> [User]
    func getUserDetailsByUserName(userName: String) async throws -> User
    func getUserDetailsByEmail(email: String) async throws -> User
    func getUserDetailsByUserId(userId: String) async throws -> User
    func updateProfileInformation(userId: String, _ model: UpdateProfileInformationModel) async throws
}
