//
//  BundleExtensions.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

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
    
    var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "Unknown"
    }
    
    var fullVersion: String {
        return "\(appVersion) (\(buildNumber))"
    }
}

