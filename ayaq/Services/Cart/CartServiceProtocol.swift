import Foundation

protocol CartServiceProtocol {
    func getCart(userId: String) async throws -> Cart
    func addItemToCart(userId: String, _ model: AddItemToCartModel) async throws -> Cart
    func updateItemQuantity(userId: String, _ model: UpdateCartItemQuantityModel) async throws -> Cart
    func removeItemFromCart(userId: String, _ model: RemoveItemFromCartModel) async throws
    func removeCart(cartId: Int) async throws
    func removeCartByUserId(userId: String) async throws
}
