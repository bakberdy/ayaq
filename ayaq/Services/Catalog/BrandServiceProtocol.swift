import Foundation

protocol BrandServiceProtocol {
    func getCatalogBrands() async throws -> [CatalogBrandDTO]
    func getCatalogBrandById(_ id: Int) async throws -> CatalogBrandDTO
    func getCatalogBrandByName(_ brandName: String) async throws -> CatalogBrandDTO
    func createCatalogBrand(_ model: CreateCatalogBrandModel) async throws -> CatalogBrandDTO
    func updateCatalogBrand(id: Int, _ model: UpdateBrandModel) async throws
    func deleteCatalogBrand(_ id: Int) async throws
}
