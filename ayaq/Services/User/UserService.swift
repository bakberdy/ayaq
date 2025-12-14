import Foundation

final class UserService: UserServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getAllUsers() async throws -> [User] {
        let dtos: [ApplicationUserDTO] = try await apiClient.request(.getAllUsers)
        return dtos.map { User(from: $0) }
    }
    
    func getUserDetailsByUserName(userName: String) async throws -> User {
        let dto: ApplicationUserDTO = try await apiClient.request(.getUserDetailsByUserName(userName))
        return User(from: dto)
    }
    
    func getUserDetailsByEmail(email: String) async throws -> User {
        let dto: ApplicationUserDTO = try await apiClient.request(.getUserDetailsByEmail(email))
        return User(from: dto)
    }
    
    func getUserDetailsByUserId(userId: String) async throws -> User {
        let dto: ApplicationUserDTO = try await apiClient.request(.getUserDetailsByUserId(userId))
        return User(from: dto)
    }
    
    func updateProfileInformation(userId: String, _ model: UpdateProfileInformationModel) async throws {
        try await apiClient.request(.updateProfileInformation(userId: userId, model))
    }
}
