import Foundation

/// Represents all possible errors that can occur during network requests
enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError(Error)
    case networkError(Error)
    case unauthorized        // HTTP 401
    case forbidden          // HTTP 403
    case notFound           // HTTP 404
    case serverError        // HTTP 500+
    case unknownError
    
    /// User-friendly error descriptions
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL format"
            
        case .requestFailed(let statusCode):
            return "Request failed with status code: \(statusCode)"
            
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
            
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
            
        case .unauthorized:
            return "Session expired. Please login again"
            
        case .forbidden:
            return "You don't have permission to access this"
            
        case .notFound:
            return "The requested resource was not found"
            
        case .serverError:
            return "Server error. Please try again later"
            
        case .unknownError:
            return "An unknown error occurred"
        }
    }
    
    /// Recovery suggestions for certain errors
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "Check your internet connection and try again"
            
        case .unauthorized:
            return "Tap 'Login' to enter your credentials"
            
        case .serverError:
            return "Please try again in a few moments"
            
        default:
            return nil
        }
    }
}
