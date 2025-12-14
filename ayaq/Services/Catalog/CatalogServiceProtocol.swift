import Foundation

protocol CatalogServiceProtocol {
    func getCatalogItems() async throws -> [Product]
    func getCatalogItemById(_ id: Int) async throws -> Product
    func getCatalogItemsByTypeName(_ typeName: String) async throws -> [Product]
    func getCatalogItemsByBrandName(_ brandName: String) async throws -> [Product]
    func createCatalogItem(_ model: CreateCatalogItemModel) async throws -> Product
    func updateCatalogItemDetails(id: Int, _ model: UpdateCatalogItemModel) async throws
    func updateCatalogItemStockQuantity(id: Int, _ model: UpdateCatalogItemStockQuantityModel) async throws
    func updateCatalogItemPictureUrl(id: Int, _ model: UpdateCatalogItemPictureUrlModel) async throws
    func deleteCatalogItem(_ id: Int) async throws
}
