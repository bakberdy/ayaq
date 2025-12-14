import Foundation

struct TokenDTO: Codable {
    let authToken: String?
}

struct ApplicationUserDTO: Codable {
    let userId: String?
    let firstName: String?
    let lastName: String?
    let userName: String?
    let email: String?
    let profilePictureUrl: String?
    let roles: [String]?
}

struct CatalogItemDTO: Codable {
    let id: Int
    let name: String?
    let description: String?
    let price: Double
    let pictureUrl: String?
    let stockQuantity: Int
    let catalogItemTypeName: String?
    let catalogItemBrandName: String?
    let catalogTypeId: Int
    let catalogBrandId: Int
    let reviews: [CatalogItemReviewDTO]?
}

struct CatalogBrandDTO: Codable {
    let id: Int
    let brand: String?
}

struct CatalogTypeDTO: Codable {
    let id: Int
    let type: String?
}

struct CartDTO: Codable {
    let id: Int
    let userId: String?
    let items: [CartItemDTO]?
    let totalPrice: Double
}

struct CartItemDTO: Codable {
    let id: Int
    let catalogItemId: Int
    let unitPrice: Double
    let quantity: Int
    let productName: String?
    let pictureUrl: String?
    let cartId: Int
    let totalPrice: Double
}

struct WishlistDTO: Codable {
    let id: Int
    let userId: String?
    let items: [WishlistItemDTO]?
}

struct WishlistItemDTO: Codable {
    let id: Int
    let catalogItemId: Int
    let productName: String?
    let pictureUrl: String?
    let wishlistId: Int
}

struct OrderDTO: Codable {
    let id: Int
    let userId: String?
    let orderDate: String
    let isConfirmed: Bool
    let shippingMethod: ShippingMethodDTO?
    let shippingDetails: ShippingDetailsDTO?
    let items: [OrderItemDTO]?
    let totalPrice: Double
}

struct OrderItemDTO: Codable {
    let id: Int
    let catalogItemId: Int
    let unitPrice: Double
    let quantity: Int
    let productName: String?
    let orderId: Int
    let totalPrice: Double
}

struct ShippingMethodDTO: Codable {
    let name: String?
    let cost: Double
    let deliveryTime: String
}

struct ShippingDetailsDTO: Codable {
    let addressToShip: String?
    let phoneNumber: String?
}

struct CatalogItemReviewDTO: Codable {
    let id: Int
    let userId: String?
    let rating: Double
    let reviewText: String?
    let createdTime: String
    let catalogItemId: Int
}

struct SalesReportDTO: Codable {
    let month: String?
    let salesCount: Int
}

struct CustomerActivityLogDTO: Codable {
    let userId: String?
    let justOrdered: Bool
    let orderDate: String
}

struct InventorySummaryDTO: Codable {
    let productName: String?
    let stockQuantity: Int
}

typealias InventoryItemDTO = InventorySummaryDTO

struct EmptyResponse: Codable {}
