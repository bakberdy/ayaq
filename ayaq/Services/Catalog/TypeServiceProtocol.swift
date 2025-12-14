import Foundation

protocol TypeServiceProtocol {
    func getCatalogTypes() async throws -> [CatalogTypeDTO]
    func getCatalogTypeById(_ id: Int) async throws -> CatalogTypeDTO
    func getCatalogTypeByName(_ typeName: String) async throws -> CatalogTypeDTO
    func createCatalogType(_ model: CreateCatalogTypeModel) async throws -> CatalogTypeDTO
    func updateCatalogType(id: Int, _ model: UpdateTypeModel) async throws
    func deleteCatalogType(_ id: Int) async throws
}
