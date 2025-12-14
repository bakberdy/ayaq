import Foundation

protocol AdminServiceProtocol {
    func getSalesReport() async throws -> [SalesReport]
    func getCustomerActivityLogs() async throws -> [CustomerActivityLog]
    func getInventorySummary() async throws -> [InventoryItem]
}
