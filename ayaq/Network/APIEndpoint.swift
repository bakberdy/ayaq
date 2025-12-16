import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIEndpoint {
    case login(LoginModel)
    case register(RegisterModel)
    case authenticateAnonymousUser
    case addUserToRoles(AddUserToRolesModel)
    case requestPasswordReset(RequestPasswordResetModel)
    case resetPassword(ResetPasswordModel)
    case changeEmail(ChangeEmailModel)
    case changePassword(ChangePasswordModel)
    case getCurrentUserId
    case getCurrentUserName
    case getPayload(String)
    
    case getAllUsers
    case getUserDetailsByUserName(String)
    case getUserDetailsByEmail(String)
    case getUserDetailsByUserId(String)
    case updateProfileInformation(userId: String, UpdateProfileInformationModel)
    
    case getSalesReport
    case getCustomerActivityLogs
    case getInventorySummary
    
    case getCatalogBrands
    case getCatalogBrandById(Int)
    case getCatalogBrandByName(String)
    case createCatalogBrand(CreateCatalogBrandModel)
    case updateCatalogBrand(id: Int, UpdateBrandModel)
    case deleteCatalogBrand(Int)
    
    case getCatalogTypes
    case getCatalogTypeById(Int)
    case getCatalogTypeByName(String)
    case createCatalogType(CreateCatalogTypeModel)
    case updateCatalogType(id: Int, UpdateTypeModel)
    case deleteCatalogType(Int)
    
    case getCatalogItems
    case getCatalogItemById(Int)
    case getCatalogItemsByTypeName(String)
    case getCatalogItemsByBrandName(String)
    case createCatalogItem(CreateCatalogItemModel)
    case updateCatalogItemDetails(id: Int, UpdateCatalogItemModel)
    case updateCatalogItemStockQuantity(id: Int, UpdateCatalogItemStockQuantityModel)
    case updateCatalogItemPictureUrl(id: Int, UpdateCatalogItemPictureUrlModel)
    case updateCatalogItemType(id: Int, UpdateCatalogTypeModel)
    case updateCatalogItemBrand(id: Int, UpdateCatalogBrandModel)
    case deleteCatalogItem(Int)
    
    case getCart(String)
    case addItemToCart(userId: String, AddItemToCartModel)
    case updateItemQuantity(userId: String, UpdateCartItemQuantityModel)
    case removeItemFromCart(userId: String, RemoveItemFromCartModel)
    case removeCart(Int)
    case removeCartByUserId(String)
    
    case getWishlist(String)
    case addItemToWishlist(userId: String, AddItemToWishlistModel)
    case removeItemFromWishlist(userId: String, RemoveItemFromWishlistModel)
    case removeWishlist(Int)
    case removeWishlistByUserId(String)
    
    case getOrders
    case getOrderById(Int)
    case getOrderByUserId(String)
    case createOrder(userId: String, CreateOrderModel)
    case confirmOrder(Int)
    
    case getCatalogItemReview(Int)
    case getReviewsByUserId(String)
    case getReviewById(Int)
    case createReview(CreateReviewModel)
    case updateReview(id: Int, UpdateReviewModel)
    case deleteReview(id: Int, DeleteReviewModel)
    
    case sendSupport(SupportRequestModel)
    
    var baseURL: String {
        return "http://3.79.185.15:5200"
    }
}

extension APIEndpoint {
    var path: String {
        switch self {
        case .login:
            return "/api/Auth/Login"
        case .register:
            return "/api/Auth/Register"
        case .authenticateAnonymousUser:
            return "/api/Auth/AuthenticateAnonymousUser"
        case .addUserToRoles:
            return "/api/Auth/AddUserToRoles"
        case .requestPasswordReset:
            return "/api/Auth/RequestPasswordReset"
        case .resetPassword:
            return "/api/Auth/ResetPassword"
        case .changeEmail:
            return "/api/Auth/ChangeEmail"
        case .changePassword:
            return "/api/Auth/ChangePassword"
        case .getCurrentUserId:
            return "/api/Auth/GetCurrentUserId"
        case .getCurrentUserName:
            return "/api/Auth/GetCurrentUserName"
        case .getPayload(let token):
            return "/api/Auth/GetPayload/\(token)"
            
        case .getAllUsers:
            return "/api/ApplicationUser/GetAllUsers"
        case .getUserDetailsByUserName(let userName):
            return "/api/ApplicationUser/GetUserDetailsByUserName/\(userName)"
        case .getUserDetailsByEmail(let email):
            return "/api/ApplicationUser/GetUserDetailsByEmail/\(email)"
        case .getUserDetailsByUserId(let userId):
            return "/api/ApplicationUser/GetUserDetailsByUserId/\(userId)"
        case .updateProfileInformation(let userId, _):
            return "/api/ApplicationUser/UpdateProfileInformation/\(userId)"
            
        case .getSalesReport:
            return "/api/AdminDashboard/SalesReport"
        case .getCustomerActivityLogs:
            return "/api/AdminDashboard/GetCustomerActivityLogs"
        case .getInventorySummary:
            return "/api/AdminDashboard/GetInventorySummary"
            
        case .getCatalogBrands:
            return "/api/CatalogBrand/GetCatalogBrands"
        case .getCatalogBrandById(let id):
            return "/api/CatalogBrand/GetCatalogBrandById/\(id)"
        case .getCatalogBrandByName(let brandName):
            return "/api/CatalogBrand/GetCatalogBrandByName/\(brandName)"
        case .createCatalogBrand:
            return "/api/CatalogBrand/CreateCatalogBrand"
        case .updateCatalogBrand(let id, _):
            return "/api/CatalogBrand/UpdateCatalogBrand/\(id)"
        case .deleteCatalogBrand(let id):
            return "/api/CatalogBrand/DeleteCatalogBrand/\(id)"
            
        case .getCatalogTypes:
            return "/api/CatalogType/GetCatalogTypes"
        case .getCatalogTypeById(let id):
            return "/api/CatalogType/GetCatalogTypeById/\(id)"
        case .getCatalogTypeByName(let typeName):
            return "/api/CatalogType/GetCatalogTypeByName/\(typeName)"
        case .createCatalogType:
            return "/api/CatalogType/CreateCatalogType"
        case .updateCatalogType(let id, _):
            return "/api/CatalogType/UpdateCatalogType/\(id)"
        case .deleteCatalogType(let id):
            return "/api/CatalogType/DeleteCatalogType/\(id)"
            
        case .getCatalogItems:
            return "/api/CatalogItem/GetCatalogItems"
        case .getCatalogItemById(let id):
            return "/api/CatalogItem/GetCatalogItemById/\(id)"
        case .getCatalogItemsByTypeName(let typeName):
            return "/api/CatalogItem/GetCatalogItemsByTypeName/\(typeName)"
        case .getCatalogItemsByBrandName(let brandName):
            return "/api/CatalogItem/GetCatalogItemsByBrandName/\(brandName)"
        case .createCatalogItem:
            return "/api/CatalogItem/CreateCatalogItem"
        case .updateCatalogItemDetails(let id, _):
            return "/api/CatalogItem/UpdateCatalogItemDetails/\(id)"
        case .updateCatalogItemStockQuantity(let id, _):
            return "/api/CatalogItem/UpdateCatalogItemStockQuantity/\(id)"
        case .updateCatalogItemPictureUrl(let id, _):
            return "/api/CatalogItem/UpdateCatalogItemPictureUrl/\(id)"
        case .updateCatalogItemType(let id, _):
            return "/api/CatalogItem/UpdateCatalogType/\(id)"
        case .updateCatalogItemBrand(let id, _):
            return "/api/CatalogItem/UpdateCatalogBrand/\(id)"
        case .deleteCatalogItem(let id):
            return "/api/CatalogItem/DeleteCatalogItem/\(id)"
            
        case .getCart(let userId):
            return "/api/Cart/GetCart/\(userId)"
        case .addItemToCart(let userId, _):
            return "/api/Cart/AddItemToCart?userId=\(userId)"
        case .updateItemQuantity(let userId, _):
            return "/api/Cart/UpdateItemQuantity/\(userId)"
        case .removeItemFromCart(let userId, _):
            return "/api/Cart/RemoveItemFromCart/\(userId)"
        case .removeCart(let cartId):
            return "/api/Cart/RemoveCart/\(cartId)"
        case .removeCartByUserId(let userId):
            return "/api/Cart/RemoveCartByUserId/\(userId)"
            
        case .getWishlist(let userId):
            return "/api/Wishlist/GetWishlist/\(userId)"
        case .addItemToWishlist(let userId, _):
            return "/api/Wishlist/AddItemToWishlist?userId=\(userId)"
        case .removeItemFromWishlist(let userId, _):
            return "/api/Wishlist/RemoveItemFromWishlist/\(userId)"
        case .removeWishlist(let wishlistId):
            return "/api/Wishlist/RemoveWishlist/\(wishlistId)"
        case .removeWishlistByUserId(let userId):
            return "/api/Wishlist/RemoveWishlistByUserId/\(userId)"
            
        case .getOrders:
            return "/api/Order/GetOrders"
        case .getOrderById(let orderId):
            return "/api/Order/GetOrderById/\(orderId)"
        case .getOrderByUserId(let userId):
            return "/api/Order/GetOrderByUserId/\(userId)"
        case .createOrder(let userId, _):
            return "/api/Order/CreateOrder/\(userId)"
        case .confirmOrder(let orderId):
            return "/api/Order/ConfirmOrder/\(orderId)"
            
        case .getCatalogItemReview(let catalogItemId):
            return "/api/Review/GetCatalogItemReview/\(catalogItemId)"
        case .getReviewsByUserId(let userId):
            return "/api/Review/GetReviewsByUserId/\(userId)"
        case .getReviewById(let id):
            return "/api/Review/GetReviewById/\(id)"
        case .createReview:
            return "/api/Review/CreateReview"
        case .updateReview(let id, _):
            return "/api/Review/UpdateReview/\(id)"
        case .deleteReview(let id, _):
            return "/api/Review/DeleteReview/\(id)"
            
        case .sendSupport:
            return "/api/Support/SendSupport"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllUsers, .getUserDetailsByUserName, .getUserDetailsByEmail, .getUserDetailsByUserId,
             .getCurrentUserId, .getCurrentUserName, .getPayload,
             .getSalesReport, .getCustomerActivityLogs, .getInventorySummary,
             .getCatalogBrands, .getCatalogBrandById, .getCatalogBrandByName,
             .getCatalogTypes, .getCatalogTypeById, .getCatalogTypeByName,
             .getCatalogItems, .getCatalogItemById, .getCatalogItemsByTypeName, .getCatalogItemsByBrandName,
             .getCart, .getWishlist,
             .getOrders, .getOrderById, .getOrderByUserId,
             .getCatalogItemReview, .getReviewsByUserId, .getReviewById:
            return .get
            
        case .login, .register, .authenticateAnonymousUser, .addUserToRoles,
             .requestPasswordReset, .resetPassword, .changeEmail, .changePassword,
             .createCatalogBrand, .createCatalogType, .createCatalogItem,
             .addItemToCart, .addItemToWishlist,
             .createOrder, .confirmOrder,
             .createReview, .sendSupport:
            return .post
            
        case .updateProfileInformation, .updateCatalogBrand, .updateCatalogType,
             .updateCatalogItemDetails, .updateCatalogItemStockQuantity, .updateCatalogItemPictureUrl,
             .updateCatalogItemType, .updateCatalogItemBrand, .updateItemQuantity, .updateReview:
            return .put
            
        case .deleteCatalogBrand, .deleteCatalogType, .deleteCatalogItem,
             .removeItemFromCart, .removeCart, .removeCartByUserId,
             .removeItemFromWishlist, .removeWishlist, .removeWishlistByUserId,
             .deleteReview:
            return .delete
        }
    }
    
    var body: Encodable? {
        switch self {
        case .login(let model):
            return model
        case .register(let model):
            return model
        case .addUserToRoles(let model):
            return model
        case .requestPasswordReset(let model):
            return model
        case .resetPassword(let model):
            return model
        case .changeEmail(let model):
            return model
        case .changePassword(let model):
            return model
            
        case .updateProfileInformation(_, let model):
            return model
            
        case .createCatalogBrand(let model):
            return model
        case .updateCatalogBrand(_, let model):
            return model
            
        case .createCatalogType(let model):
            return model
        case .updateCatalogType(_, let model):
            return model
            
        case .createCatalogItem(let model):
            return model
        case .updateCatalogItemDetails(_, let model):
            return model
        case .updateCatalogItemStockQuantity(_, let model):
            return model
        case .updateCatalogItemPictureUrl(_, let model):
            return model
        case .updateCatalogItemType(_, let model):
            return model
        case .updateCatalogItemBrand(_, let model):
            return model
            
        case .addItemToCart(_, let model):
            return model
        case .updateItemQuantity(_, let model):
            return model
        case .removeItemFromCart(_, let model):
            return model
            
        case .addItemToWishlist(_, let model):
            return model
        case .removeItemFromWishlist(_, let model):
            return model
            
        case .createOrder(_, let model):
            return model
            
        case .createReview(let model):
            return model
        case .updateReview(_, let model):
            return model
        case .deleteReview(_, let model):
            return model
            
        case .sendSupport(let model):
            return model
            
        default:
            return nil
        }
    }
}
