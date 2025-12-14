import Foundation

protocol ReviewServiceProtocol {
    func getCatalogItemReview(catalogItemId: Int) async throws -> [Review]
    func getReviewsByUserId(userId: String) async throws -> [Review]
    func getReviewById(id: Int) async throws -> Review
    func createReview(_ model: CreateReviewModel) async throws -> Review
    func updateReview(id: Int, _ model: UpdateReviewModel) async throws
    func deleteReview(id: Int, _ model: DeleteReviewModel) async throws
}
