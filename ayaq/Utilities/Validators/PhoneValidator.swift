
import Foundation

struct PhoneValidator {
    
    static func isValid(_ phone: String) -> Bool {
        let trimmedPhone = phone.trimmed.replacingOccurrences(of: " ", with: "")
        guard !trimmedPhone.isEmpty else { return false }
        
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: trimmedPhone)
    }
    
    static func validate(_ phone: String) -> ValidationResult {
        let trimmedPhone = phone.trimmed
        
        guard !trimmedPhone.isEmpty else {
            return .failure("Phone number is required")
        }
        
        let cleanedPhone = trimmedPhone.replacingOccurrences(of: " ", with: "")
        
        guard isValid(cleanedPhone) else {
            return .failure("Invalid phone number format")
        }
        
        return .success
    }
    
    static func format(_ phone: String) -> String {
        let cleanedPhone = phone.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        return cleanedPhone
    }
}

