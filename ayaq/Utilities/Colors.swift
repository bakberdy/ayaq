import UIKit

enum AppColors {
    static let primary = UIColor(hex: "#F83758")
    static let primaryLight = UIColor(hex: "#FF5B7A")
    static let primaryDark = UIColor(hex: "#C92140")
    
    static let background = UIColor(hex: "#FFFFFF")
    static let surface = UIColor(hex: "#F5F5F5")
    
    static let textPrimary = UIColor(hex: "#212121")
    static let textSecondary = UIColor(hex: "#757575")
    
    static let divider = UIColor(hex: "#E0E0E0")
    
    static let error = UIColor(hex: "#D32F2F")
    static let success = UIColor(hex: "#388E3C")
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
