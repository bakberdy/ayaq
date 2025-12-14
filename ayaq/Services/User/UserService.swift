import Foundation

final class UserService: UserServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getAllUsers() async throws -> [ApplicationUserDTO] {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getAllUsers, expecting: [ApplicationUserDTO].self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getUserDetailsByUserName(userName: String) async throws -> ApplicationUserDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getUserDetailsByUserName(userName), expecting: ApplicationUserDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getUserDetailsByEmail(email: String) async throws -> ApplicationUserDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getUserDetailsByEmail(email), expecting: ApplicationUserDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getUserDetailsByUserId(userId: String) async throws -> ApplicationUserDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getUserDetailsByUserId(userId), expecting: ApplicationUserDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func updateProfileInformation(userId: String, _ model: UpdateProfileInformationModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.updateProfileInformation(userId: userId, model)) { result in
                continuation.resume(with: result)
            }
        }
    }
}
