//
//  EmailValidator.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

import Foundation

struct EmailValidator {
    
    static func isValid(_ email: String) -> Bool {
        let trimmedEmail = email.trimmed
        guard !trimmedEmail.isEmpty else { return false }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: trimmedEmail)
    }
    
    static func validate(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmed
        
        guard !trimmedEmail.isEmpty else {
            return .failure("Email is required")
        }
        
        guard isValid(trimmedEmail) else {
            return .failure("Invalid email format")
        }
        
        return .success
    }
}

