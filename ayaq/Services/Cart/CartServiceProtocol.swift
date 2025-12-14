import Foundation

protocol CartServiceProtocol {
    func getCart(userId: String) async throws -> CartDTO
    func addItemToCart(userId: String, _ model: AddItemToCartModel) async throws -> CartDTO
    func updateItemQuantity(userId: String, _ model: UpdateCartItemQuantityModel) async throws -> CartDTO
    func removeItemFromCart(userId: String, _ model: RemoveItemFromCartModel) async throws
    func removeCart(cartId: Int) async throws
    func removeCartByUserId(userId: String) async throws
}
