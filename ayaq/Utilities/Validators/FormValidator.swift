//
//  FormValidator.swift
//  ayaq
//
//  Created by Bakberdi Esentai on 14.12.2025.
//

import Foundation

enum ValidationResult {
    case success
    case failure(String)
    
    var isValid: Bool {
        if case .success = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .failure(let message) = self {
            return message
        }
        return nil
    }
}

struct FormValidator {
    
    static func validateRequired(_ value: String, fieldName: String) -> ValidationResult {
        let trimmedValue = value.trimmed
        guard !trimmedValue.isEmpty else {
            return .failure("\(fieldName) is required")
        }
        return .success
    }
    
    static func validateMinLength(_ value: String, minLength: Int, fieldName: String) -> ValidationResult {
        guard value.count >= minLength else {
            return .failure("\(fieldName) must be at least \(minLength) characters")
        }
        return .success
    }
    
    static func validateMaxLength(_ value: String, maxLength: Int, fieldName: String) -> ValidationResult {
        guard value.count <= maxLength else {
            return .failure("\(fieldName) must not exceed \(maxLength) characters")
        }
        return .success
    }
    
    static func validateRange(_ value: String, min: Int, max: Int, fieldName: String) -> ValidationResult {
        guard value.count >= min else {
            return .failure("\(fieldName) must be at least \(min) characters")
        }
        guard value.count <= max else {
            return .failure("\(fieldName) must not exceed \(max) characters")
        }
        return .success
    }
    
    static func validateNumeric(_ value: String, fieldName: String) -> ValidationResult {
        guard Double(value) != nil else {
            return .failure("\(fieldName) must be a number")
        }
        return .success
    }
    
    static func validateAlphabetic(_ value: String, fieldName: String) -> ValidationResult {
        let alphabeticRegex = "^[a-zA-Z]+$"
        let alphabeticPredicate = NSPredicate(format: "SELF MATCHES %@", alphabeticRegex)
        guard alphabeticPredicate.evaluate(with: value) else {
            return .failure("\(fieldName) must contain only letters")
        }
        return .success
    }
    
    static func validateAlphanumeric(_ value: String, fieldName: String) -> ValidationResult {
        let alphanumericRegex = "^[a-zA-Z0-9]+$"
        let alphanumericPredicate = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
        guard alphanumericPredicate.evaluate(with: value) else {
            return .failure("\(fieldName) must contain only letters and numbers")
        }
        return .success
    }
    
    static func validateMultiple(_ validations: [ValidationResult]) -> ValidationResult {
        for validation in validations {
            if case .failure(let message) = validation {
                return .failure(message)
            }
        }
        return .success
    }
}

