# Network Layer Documentation

## Overview

This is a complete, production-ready network layer for your iOS app. It handles all HTTP communication with your backend API, including authentication, error handling, and request/response mapping.

## Architecture

```
Network/
├── APIError.swift                    # All possible network errors
├── APIEndpoint.swift                 # All API endpoints (type-safe)
├── APIClient.swift                   # Main HTTP client
├── Interceptors/
│   └── AuthenticationInterceptor.swift  # Adds JWT token to requests
├── NetworkModels/
│   ├── RequestModels.swift           # Models for sending data to API
│   └── DTOs.swift                    # Models for receiving data from API
└── Managers/
    └── TokenManager.swift            # JWT token storage/retrieval
```

## Key Features

✅ Type-safe API endpoints
✅ Automatic JWT token injection
✅ Comprehensive error handling
✅ Generic request methods
✅ Based on your swagger.json spec
✅ Codable support for all models
✅ Singleton pattern for easy access

## Quick Start

### 1. Update Base URL

Open [APIEndpoint.swift](APIEndpoint.swift) and update the base URL:

```swift
var baseURL: String {
    return "https://your-actual-api-domain.com"  // <-- Change this
}
```

### 2. Make Your First Request

#### Example: Login

```swift
let loginModel = LoginModel(
    email: "user@example.com",
    password: "password123"
)

APIClient.shared.request(
    .login(loginModel),
    expecting: ApplicationUserDTO.self
) { result in
    switch result {
    case .success(let user):
        print("✅ Login successful!")
        print("User ID: \(user.userId ?? "")")
        print("Email: \(user.email ?? "")")
        
        // Save token if API returns it
        // TokenManager.shared.saveToken(token)
        
    case .failure(let error):
        print("❌ Login failed: \(error.localizedDescription)")
    }
}
```

#### Example: Get Catalog Items

```swift
APIClient.shared.request(
    .getCatalogItems,
    expecting: [CatalogItemDTO].self
) { result in
    switch result {
    case .success(let items):
        print("✅ Got \(items.count) items")
        items.forEach { item in
            print("- \(item.name ?? "") - $\(item.price)")
        }
        
    case .failure(let error):
        print("❌ Error: \(error.localizedDescription)")
    }
}
```

#### Example: Add to Cart

```swift
guard let userId = TokenManager.shared.getUserId() else {
    print("User not logged in")
    return
}

let addModel = AddItemToCartModel(catalogItemId: 123)

APIClient.shared.request(
    .addItemToCart(userId: userId, addModel),
    expecting: CartDTO.self
) { result in
    switch result {
    case .success(let cart):
        print("✅ Item added to cart")
        print("Total items: \(cart.items?.count ?? 0)")
        print("Total price: $\(cart.totalPrice)")
        
    case .failure(let error):
        print("❌ Error: \(error.localizedDescription)")
    }
}
```

#### Example: Create Order

```swift
let orderModel = CreateOrderModel(
    deliveryName: "FedEx Standard",
    deliveryCost: 9.99,
    deliveryTime: 5,
    addressToShip: "123 Main St, City, State 12345",
    phoneNumber: "+1234567890"
)

APIClient.shared.request(
    .createOrder(userId: userId, orderModel),
    expecting: OrderDTO.self
) { result in
    switch result {
    case .success(let order):
        print("✅ Order created!")
        print("Order ID: \(order.id)")
        print("Total: $\(order.totalPrice)")
        
    case .failure(let error):
        print("❌ Error: \(error.localizedDescription)")
    }
}
```

#### Example: Delete (No Response)

```swift
APIClient.shared.request(.deleteCatalogItem(123)) { result in
    switch result {
    case .success:
        print("✅ Item deleted successfully")
        
    case .failure(let error):
        print("❌ Error: \(error.localizedDescription)")
    }
}
```

## Token Management

### Save Token (After Login)

```swift
// After successful login
TokenManager.shared.saveToken("your-jwt-token-here")
```

### Check If User Logged In

```swift
if TokenManager.shared.hasToken() {
    // User is logged in
    showHomeScreen()
} else {
    // User not logged in
    showLoginScreen()
}
```

### Logout

```swift
TokenManager.shared.clearToken()
// Navigate to login screen
```

## Error Handling

The network layer provides comprehensive error handling:

```swift
APIClient.shared.request(.someEndpoint, expecting: SomeDTO.self) { result in
    switch result {
    case .success(let data):
        // Handle success
        
    case .failure(let error):
        // Handle specific errors
        switch error {
        case .unauthorized:
            // Session expired - show login
            TokenManager.shared.clearToken()
            showLoginScreen()
            
        case .notFound:
            // Resource not found
            showAlert("Item not found")
            
        case .networkError:
            // No internet connection
            showAlert("Check your internet connection")
            
        case .serverError:
            // Server is down
            showAlert("Server error. Try again later")
            
        default:
            // Generic error
            showAlert(error.localizedDescription)
        }
    }
}
```

## Available Endpoints

### Authentication
- `login(LoginModel)` - User login
- `register(RegisterModel)` - User registration
- `changePassword(ChangePasswordModel)` - Change password
- `changeEmail(ChangeEmailModel)` - Change email
- `requestPasswordReset(RequestPasswordResetModel)` - Request password reset
- `resetPassword(ResetPasswordModel)` - Reset password
- `getCurrentUserId` - Get current user ID
- `getCurrentUserName` - Get current username

### User Management
- `getAllUsers` - Get all users (admin)
- `getUserDetailsByUserId(String)` - Get user by ID
- `getUserDetailsByEmail(String)` - Get user by email
- `getUserDetailsByUserName(String)` - Get user by username
- `updateProfileInformation(userId: String, UpdateProfileInformationModel)` - Update profile

### Catalog Items (Products)
- `getCatalogItems` - Get all products
- `getCatalogItemById(Int)` - Get product by ID
- `getCatalogItemsByTypeName(String)` - Get products by type
- `getCatalogItemsByBrandName(String)` - Get products by brand
- `createCatalogItem(CreateCatalogItemModel)` - Create product (admin)
- `updateCatalogItemDetails(id: Int, UpdateCatalogItemModel)` - Update product
- `deleteCatalogItem(Int)` - Delete product (admin)

### Brands
- `getCatalogBrands` - Get all brands
- `getCatalogBrandById(Int)` - Get brand by ID
- `getCatalogBrandByName(String)` - Get brand by name
- `createCatalogBrand(CreateCatalogBrandModel)` - Create brand (admin)
- `updateCatalogBrand(id: Int, UpdateBrandModel)` - Update brand
- `deleteCatalogBrand(Int)` - Delete brand (admin)

### Types (Categories)
- `getCatalogTypes` - Get all types
- `getCatalogTypeById(Int)` - Get type by ID
- `getCatalogTypeByName(String)` - Get type by name
- `createCatalogType(CreateCatalogTypeModel)` - Create type (admin)
- `updateCatalogType(id: Int, UpdateTypeModel)` - Update type
- `deleteCatalogType(Int)` - Delete type (admin)

### Shopping Cart
- `getCart(String)` - Get user's cart
- `addItemToCart(userId: String, AddItemToCartModel)` - Add item to cart
- `updateItemQuantity(userId: String, UpdateCartItemQuantityModel)` - Update quantity
- `removeItemFromCart(userId: String, RemoveItemFromCartModel)` - Remove item
- `removeCart(Int)` - Clear entire cart

### Wishlist
- `getWishlist(String)` - Get user's wishlist
- `addItemToWishlist(userId: String, AddItemToWishlistModel)` - Add to wishlist
- `removeItemFromWishlist(userId: String, RemoveItemFromWishlistModel)` - Remove from wishlist

### Orders
- `getOrders` - Get all orders (admin)
- `getOrderById(Int)` - Get order by ID
- `getOrderByUserId(String)` - Get user's orders
- `createOrder(userId: String, CreateOrderModel)` - Create order
- `confirmOrder(Int)` - Confirm order

### Reviews
- `getCatalogItemReview(Int)` - Get reviews for product
- `getReviewsByUserId(String)` - Get user's reviews
- `createReview(CreateReviewModel)` - Create review
- `updateReview(id: Int, UpdateReviewModel)` - Update review
- `deleteReview(id: Int, DeleteReviewModel)` - Delete review

### Admin Dashboard
- `getSalesReport` - Get sales report
- `getCustomerActivityLogs` - Get customer activity
- `getInventorySummary` - Get inventory summary

### Support
- `sendSupport(SupportRequestModel)` - Send support request

## How It Works

### 1. Request Flow

```
APIClient.request()
    ↓
Build URL from endpoint
    ↓
Create URLRequest
    ↓
AuthenticationInterceptor adds JWT token
    ↓
Encode request body (if exists)
    ↓
Make HTTP request
    ↓
Handle response
    ↓
Decode JSON to model
    ↓
Return Result<Model, APIError>
```

### 2. Authentication Interceptor

Every request automatically includes the JWT token if available:

```
Before Interceptor:
GET /api/CatalogItem/GetCatalogItems
Headers: { Content-Type: application/json }

After Interceptor:
GET /api/CatalogItem/GetCatalogItems
Headers: {
  Content-Type: application/json
  Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
}
```

### 3. Error Mapping

HTTP Status → APIError:
- 401 → `.unauthorized` (session expired)
- 403 → `.forbidden` (no permission)
- 404 → `.notFound` (resource not found)
- 500+ → `.serverError` (server error)
- Network issues → `.networkError` (no internet)
- JSON parsing → `.decodingError` (invalid response)

## Best Practices

### 1. Always Handle Errors

```swift
// ❌ Bad
APIClient.shared.request(.getCatalogItems, expecting: [CatalogItemDTO].self) { result in
    let items = try! result.get()  // Don't do this!
}

// ✅ Good
APIClient.shared.request(.getCatalogItems, expecting: [CatalogItemDTO].self) { result in
    switch result {
    case .success(let items):
        // Handle success
    case .failure(let error):
        // Handle error properly
        showErrorAlert(error.localizedDescription)
    }
}
```

### 2. Update UI on Main Thread

```swift
APIClient.shared.request(.getCatalogItems, expecting: [CatalogItemDTO].self) { result in
    DispatchQueue.main.async {
        switch result {
        case .success(let items):
            self.tableView.reloadData()
        case .failure(let error):
            self.showAlert(error.localizedDescription)
        }
    }
}
```

### 3. Use Weak Self in Closures

```swift
APIClient.shared.request(.getCatalogItems, expecting: [CatalogItemDTO].self) { [weak self] result in
    guard let self = self else { return }
    
    DispatchQueue.main.async {
        // Update UI
    }
}
```

## Testing

### Test Token Manager

```swift
// Save token
TokenManager.shared.saveToken("test-token-123")
assert(TokenManager.shared.hasToken() == true)

// Get token
let token = TokenManager.shared.getToken()
assert(token == "test-token-123")

// Clear token
TokenManager.shared.clearToken()
assert(TokenManager.shared.hasToken() == false)
```

### Test API Calls

```swift
let expectation = XCTestExpectation(description: "Get catalog items")

APIClient.shared.request(.getCatalogItems, expecting: [CatalogItemDTO].self) { result in
    switch result {
    case .success(let items):
        XCTAssertFalse(items.isEmpty)
        expectation.fulfill()
    case .failure(let error):
        XCTFail("Request failed: \(error)")
    }
}

wait(for: [expectation], timeout: 10.0)
```

## Troubleshooting

### Issue: "Invalid URL"
**Solution:** Check that baseURL is set correctly in APIEndpoint.swift

### Issue: "Unauthorized" errors
**Solution:** Check that token is saved after login:
```swift
TokenManager.shared.saveToken(token)
```

### Issue: "Decoding error"
**Solution:** Ensure DTO models match API response exactly. Check property names and types.

### Issue: Network timeout
**Solution:** Increase timeout in APIClient.swift or check internet connection

## Next Steps

1. ✅ Network Layer complete
2. 📝 Create **Services** layer (AuthService, CatalogService, etc.)
3. 📝 Create **ViewModels** with Observable pattern
4. 📝 Create **ViewControllers** with UI

The Network Layer is ready to use! 🎉
