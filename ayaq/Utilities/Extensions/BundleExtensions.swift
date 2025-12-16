
import Foundation

extension Bundle {
    
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? "Unknown"
    }
    
    var fullVersion: String {
        return "\(appVersion) (\(buildNumber))"
    }
}

