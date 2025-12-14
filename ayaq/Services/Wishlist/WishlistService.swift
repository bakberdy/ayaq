import Foundation

final class WishlistService: WishlistServiceProtocol {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getWishlist(userId: String) async throws -> WishlistDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.getWishlist(userId), expecting: WishlistDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func addItemToWishlist(userId: String, _ model: AddItemToWishlistModel) async throws -> WishlistDTO {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.addItemToWishlist(userId: userId, model), expecting: WishlistDTO.self) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func removeItemFromWishlist(userId: String, _ model: RemoveItemFromWishlistModel) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.removeItemFromWishlist(userId: userId, model), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func removeWishlist(wishlistId: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.removeWishlist(wishlistId), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
    
    func removeWishlistByUserId(userId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.request(.removeWishlistByUserId(userId), expecting: EmptyResponse.self) { result in
                continuation.resume(with: result.map { _ in () })
            }
        }
    }
}
