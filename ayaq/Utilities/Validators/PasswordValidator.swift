
import Foundation

struct PasswordValidator {
    
    static func isValid(_ password: String, requireStrong: Bool = false) -> Bool {
        if requireStrong {
            return isStrongPassword(password)
        } else {
            return password.count >= 8
        }
    }
    
    static func isStrongPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSpecialChar = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        
        return hasUppercase && hasLowercase && hasNumber && hasSpecialChar
    }
    
    static func validate(_ password: String, requireStrong: Bool = false) -> ValidationResult {
        guard !password.isEmpty else {
            return .failure("Password is required")
        }
        
        guard password.count >= 8 else {
            return .failure("Password must be at least 8 characters")
        }
        
        if requireStrong {
            guard password.range(of: "[A-Z]", options: .regularExpression) != nil else {
                return .failure("Password must contain at least one uppercase letter")
            }
            
            guard password.range(of: "[a-z]", options: .regularExpression) != nil else {
                return .failure("Password must contain at least one lowercase letter")
            }
            
            guard password.range(of: "[0-9]", options: .regularExpression) != nil else {
                return .failure("Password must contain at least one number")
            }
            
            guard password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil else {
                return .failure("Password must contain at least one special character")
            }
        }
        
        return .success
    }
    
    static func validateConfirmation(password: String, confirmation: String) -> ValidationResult {
        guard !confirmation.isEmpty else {
            return .failure("Password confirmation is required")
        }
        
        guard password == confirmation else {
            return .failure("Passwords do not match")
        }
        
        return .success
    }
}

