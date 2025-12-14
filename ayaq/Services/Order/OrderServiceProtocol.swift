import Foundation

protocol OrderServiceProtocol {
    func getOrders() async throws -> [OrderDTO]
    func getOrderById(orderId: Int) async throws -> OrderDTO
    func getOrderByUserId(userId: String) async throws -> [OrderDTO]
    func createOrder(userId: String, _ model: CreateOrderModel) async throws -> OrderDTO
    func confirmOrder(orderId: Int) async throws
}
