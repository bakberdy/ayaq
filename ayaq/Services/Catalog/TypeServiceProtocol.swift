import Foundation

protocol TypeServiceProtocol {
    func getCatalogTypes() async throws -> [ProductType]
    func getCatalogTypeById(_ id: Int) async throws -> ProductType
    func getCatalogTypeByName(_ typeName: String) async throws -> ProductType
    func createCatalogType(_ model: CreateCatalogTypeModel) async throws -> ProductType
    func updateCatalogType(id: Int, _ model: UpdateTypeModel) async throws
    func deleteCatalogType(_ id: Int) async throws
}
