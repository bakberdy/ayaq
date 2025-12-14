import Foundation

enum Constants {
    enum API {
        static let baseURL = "http://3.79.185.15:5200"
        static let timeout: TimeInterval = 30
    }
    
    enum Keychain {
        static let accessTokenKey = "com.ayaq.accessToken"
        static let refreshTokenKey = "com.ayaq.refreshToken"
    }
    
    enum UserDefaults {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let selectedLanguage = "selectedLanguage"
    }
    
    enum UI {
        static let cornerRadius: CGFloat = 8
        static let defaultPadding: CGFloat = 16
        static let animationDuration: TimeInterval = 0.3
    }
}
