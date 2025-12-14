import Foundation

protocol ReviewServiceProtocol {
    func getCatalogItemReview(catalogItemId: Int) async throws -> [CatalogItemReviewDTO]
    func getReviewsByUserId(userId: String) async throws -> [CatalogItemReviewDTO]
    func getReviewById(id: Int) async throws -> CatalogItemReviewDTO
    func createReview(_ model: CreateReviewModel) async throws -> CatalogItemReviewDTO
    func updateReview(id: Int, _ model: UpdateReviewModel) async throws
    func deleteReview(id: Int, _ model: DeleteReviewModel) async throws
}
