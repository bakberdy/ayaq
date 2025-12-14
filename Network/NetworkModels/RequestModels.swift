import Foundation

struct LoginModel: Codable {
    let email: String
    let password: String
}

struct RegisterModel: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let profilePictureUrl: String?
}

struct ChangePasswordModel: Codable {
    let email: String
    let oldPassword: String
    let newPassword: String
}

struct ChangeEmailModel: Codable {
    let oldEmail: String
    let newEmail: String
}

struct RequestPasswordResetModel: Codable {
    let email: String
    let linkToResetPassword: String
}

struct ResetPasswordModel: Codable {
    let email: String
    let code: Int
    let newPassword: String
}

struct AddUserToRolesModel: Codable {
    let email: String
    let roles: [String]
}

struct CreateCatalogItemModel: Codable {
    let name: String
    let description: String
    let price: Double
    let pictureUrl: String?
    let stockQuantity: Int
    let catalogTypeId: Int
    let catalogBrandId: Int
}

struct UpdateCatalogItemModel: Codable {
    let name: String?
    let description: String?
    let price: Double
}

struct UpdateCatalogItemStockQuantityModel: Codable {
    let stockQuantity: Int
}

struct UpdateCatalogItemPictureUrlModel: Codable {
    let pictureUrl: String
}

struct UpdateCatalogTypeModel: Codable {
    let catalogTypeId: Int
}

struct UpdateCatalogBrandModel: Codable {
    let catalogBrandId: Int
}

struct CreateCatalogBrandModel: Codable {
    let brand: String
}

struct UpdateBrandModel: Codable {
    let brand: String
}

struct CreateCatalogTypeModel: Codable {
    let type: String?
}

struct UpdateTypeModel: Codable {
    let type: String
}

struct AddItemToCartModel: Codable {
    let catalogItemId: Int
}

struct UpdateCartItemQuantityModel: Codable {
    let catalogItemId: Int
    let quantity: Int
}

struct RemoveItemFromCartModel: Codable {
    let catalogItemId: Int
}

struct AddItemToWishlistModel: Codable {
    let catalogItemId: Int
}

struct RemoveItemFromWishlistModel: Codable {
    let catalogItemId: Int
}

struct CreateOrderModel: Codable {
    let deliveryName: String
    let deliveryCost: Double
    let deliveryTime: Int
    let addressToShip: String
    let phoneNumber: String
}

struct CreateReviewModel: Codable {
    let userId: String
    let rating: Double
    let reviewText: String
    let catalogItemId: Int
}

struct UpdateReviewModel: Codable {
    let userId: String
    let rating: Double
    let reviewText: String?
}

struct DeleteReviewModel: Codable {
    let userId: String
}

struct UpdateProfileInformationModel: Codable {
    let firstName: String?
    let lastName: String?
    let profilePictureUrl: String?
}

struct SupportRequestModel: Codable {
    let fistName: String
    let lastName: String
    let subject: String
    let message: String
}
