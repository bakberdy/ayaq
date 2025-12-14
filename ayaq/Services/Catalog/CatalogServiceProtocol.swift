import Foundation

protocol CatalogServiceProtocol {
    func getCatalogItems() async throws -> [CatalogItemDTO]
    func getCatalogItemById(_ id: Int) async throws -> CatalogItemDTO
    func getCatalogItemsByTypeName(_ typeName: String) async throws -> [CatalogItemDTO]
    func getCatalogItemsByBrandName(_ brandName: String) async throws -> [CatalogItemDTO]
    func createCatalogItem(_ model: CreateCatalogItemModel) async throws -> CatalogItemDTO
    func updateCatalogItemDetails(id: Int, _ model: UpdateCatalogItemModel) async throws
    func updateCatalogItemStockQuantity(id: Int, _ model: UpdateCatalogItemStockQuantityModel) async throws
    func updateCatalogItemPictureUrl(id: Int, _ model: UpdateCatalogItemPictureUrlModel) async throws
    func deleteCatalogItem(_ id: Int) async throws
}
