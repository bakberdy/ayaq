import Foundation

extension User {
    init(from dto: ApplicationUserDTO) {
        self.id = dto.userId ?? ""
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.userName = dto.userName
        self.email = dto.email
        self.profilePictureUrl = dto.profilePictureUrl
        self.roles = dto.roles?.compactMap { UserRole(rawValue: $0) }
    }
}

extension ProductType {
    init(from dto: CatalogTypeDTO) {
        self.id = dto.id
        self.name = dto.type
    }
}

extension Brand {
    init(from dto: CatalogBrandDTO) {
        self.id = dto.id
        self.name = dto.brand
    }
}

extension Product {
    init(from dto: CatalogItemDTO) {
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
        self.price = Decimal(dto.price)
        self.imageURL = URL(string: dto.pictureUrl ?? "")
        self.stockQuantity = dto.stockQuantity
        
        self.type = ProductType(
            id: dto.catalogTypeId,
            name: dto.catalogItemTypeName
        )
        
        self.brand = Brand(
            id: dto.catalogBrandId,
            name: dto.catalogItemBrandName
        )
        
        self.reviews = dto.reviews?.map { Review(from: $0) }
    }
}

extension Review {
    init(from dto: CatalogItemReviewDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.rating = dto.rating
        self.reviewText = dto.reviewText
        self.catalogItemId = dto.catalogItemId
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.createdTime = dateFormatter.date(from: dto.createdTime)
    }
}

extension CartItem {
    init(from dto: CartItemDTO) {
        self.id = dto.id
        self.catalogItemId = dto.catalogItemId
        self.unitPrice = Decimal(dto.unitPrice)
        self.quantity = dto.quantity
        self.productName = dto.productName
        self.imageURL = URL(string: dto.pictureUrl ?? "")
        self.cartId = dto.cartId
    }
}

extension Cart {
    init(from dto: CartDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.items = dto.items?.map { CartItem(from: $0) }
    }
}

extension OrderItem {
    init(from dto: OrderItemDTO) {
        self.id = dto.id
        self.catalogItemId = dto.catalogItemId
        self.unitPrice = Decimal(dto.unitPrice)
        self.quantity = dto.quantity
        self.productName = dto.productName
        self.orderId = dto.orderId
    }
}

extension ShippingMethod {
    init(from dto: ShippingMethodDTO) {
        self.name = dto.name
        self.cost = Decimal(dto.cost)
        self.deliveryTime = dto.deliveryTime
    }
}

extension ShippingDetails {
    init(from dto: ShippingDetailsDTO) {
        self.addressToShip = dto.addressToShip
        self.phoneNumber = dto.phoneNumber
    }
}

extension Order {
    init(from dto: OrderDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.isConfirmed = dto.isConfirmed
        self.shippingMethod = dto.shippingMethod.map { ShippingMethod(from: $0) }
        self.shippingDetails = dto.shippingDetails.map { ShippingDetails(from: $0) }
        self.items = dto.items?.map { OrderItem(from: $0) }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.orderDate = dateFormatter.date(from: dto.orderDate)
    }
}

extension WishlistItem {
    init(from dto: WishlistItemDTO) {
        self.id = dto.id
        self.catalogItemId = dto.catalogItemId
        self.productName = dto.productName
        self.imageURL = URL(string: dto.pictureUrl ?? "")
        self.wishlistId = dto.wishlistId
    }
}

extension Wishlist {
    init(from dto: WishlistDTO) {
        self.id = dto.id
        self.userId = dto.userId
        self.items = dto.items?.map { WishlistItem(from: $0) }
    }
}

extension AuthToken {
    init(from dto: TokenDTO) {
        self.token = dto.authToken ?? ""
    }
}

extension JwtPayload {
    init(from dto: JwtPayloadDTO) {
        self.userId = dto.nameId
        self.userName = dto.name
        self.roles = dto.roles?.compactMap { UserRole(rawValue: $0) }
        self.notBefore = Date(timeIntervalSince1970: TimeInterval(dto.notBefore))
        self.expires = Date(timeIntervalSince1970: TimeInterval(dto.expires))
        self.issuedAt = Date(timeIntervalSince1970: TimeInterval(dto.issuedAt))
    }
}

extension SalesReport {
    init(from dto: SalesReportDTO) {
        self.month = dto.month
        self.salesCount = dto.salesCount
    }
}

extension CustomerActivityLog {
    init(from dto: CustomerActivityLogDTO) {
        self.userId = dto.userId
        self.justOrdered = dto.justOrdered
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.orderDate = dateFormatter.date(from: dto.orderDate)
    }
}

extension InventoryItem {
    init(from dto: InventorySummaryDTO) {
        self.productName = dto.productName
        self.stockQuantity = dto.stockQuantity
    }
}
