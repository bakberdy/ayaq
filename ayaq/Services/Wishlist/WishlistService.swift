import Foundation

final class WishlistService: WishlistServiceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func getWishlist(userId: String) async throws -> Wishlist {
        let dto: WishlistDTO = try await apiClient.request(.getWishlist(userId))
        return Wishlist(from: dto)
    }
    
    func addItemToWishlist(userId: String, _ model: AddItemToWishlistModel) async throws -> Wishlist {
        let dto: WishlistDTO = try await apiClient.request(.addItemToWishlist(userId: userId, model))
        return Wishlist(from: dto)
    }
    
    func removeItemFromWishlist(userId: String, _ model: RemoveItemFromWishlistModel) async throws {
        try await apiClient.request(.removeItemFromWishlist(userId: userId, model))
    }
    
    func removeWishlist(wishlistId: Int) async throws {
        try await apiClient.request(.removeWishlist(wishlistId))
    }
    
    func removeWishlistByUserId(userId: String) async throws {
        try await apiClient.request(.removeWishlistByUserId(userId))
    }
}
