import Foundation

protocol OrderServiceProtocol {
    func getOrders() async throws -> [Order]
    func getOrderById(orderId: Int) async throws -> Order
    func getOrderByUserId(userId: String) async throws -> [Order]
    func createOrder(userId: String, _ model: CreateOrderModel) async throws -> Order
    func confirmOrder(orderId: Int) async throws
}
