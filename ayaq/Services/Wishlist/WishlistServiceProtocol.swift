import Foundation

protocol WishlistServiceProtocol {
    func getWishlist(userId: String) async throws -> Wishlist
    func addItemToWishlist(userId: String, _ model: AddItemToWishlistModel) async throws -> Wishlist
    func removeItemFromWishlist(userId: String, _ model: RemoveItemFromWishlistModel) async throws
    func removeWishlist(wishlistId: Int) async throws
    func removeWishlistByUserId(userId: String) async throws
}
