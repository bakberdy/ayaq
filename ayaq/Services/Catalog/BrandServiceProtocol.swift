import Foundation

protocol BrandServiceProtocol {
    func getCatalogBrands() async throws -> [Brand]
    func getCatalogBrandById(_ id: Int) async throws -> Brand
    func getCatalogBrandByName(_ brandName: String) async throws -> Brand
    func createCatalogBrand(_ model: CreateCatalogBrandModel) async throws -> Brand
    func updateCatalogBrand(id: Int, _ model: UpdateBrandModel) async throws
    func deleteCatalogBrand(_ id: Int) async throws
}
