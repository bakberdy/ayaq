import Foundation

protocol AdminServiceProtocol {
    func getSalesReport() async throws -> [SalesReportDTO]
    func getCustomerActivityLogs() async throws -> [CustomerActivityLogDTO]
    func getInventorySummary() async throws -> [InventoryItemDTO]
}
