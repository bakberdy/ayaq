import Foundation

protocol UserServiceProtocol {
    func getAllUsers() async throws -> [ApplicationUserDTO]
    func getUserDetailsByUserName(userName: String) async throws -> ApplicationUserDTO
    func getUserDetailsByEmail(email: String) async throws -> ApplicationUserDTO
    func getUserDetailsByUserId(userId: String) async throws -> ApplicationUserDTO
    func updateProfileInformation(userId: String, _ model: UpdateProfileInformationModel) async throws
}
