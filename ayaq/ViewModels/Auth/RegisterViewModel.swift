import Foundation

final class RegisterViewModel {
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var profilePictureUrl: String = ""
    
    var onRegisterSuccess: (() -> Void)?
    var onRegisterError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func register() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            self?.onRegisterSuccess?()
        }
    }
    
    private func validateInputs() -> Bool {
        guard !firstName.isEmpty else {
            onRegisterError?("First name cannot be empty")
            return false
        }
        
        guard !lastName.isEmpty else {
            onRegisterError?("Last name cannot be empty")
            return false
        }
        
        guard !email.isEmpty else {
            onRegisterError?("Email cannot be empty")
            return false
        }
        
        guard EmailValidator.isValid(email) else {
            onRegisterError?("Please enter a valid email")
            return false
        }
        
        guard !password.isEmpty else {
            onRegisterError?("Password cannot be empty")
            return false
        }
        
        guard password.count >= 6 else {
            onRegisterError?("Password must be at least 6 characters")
            return false
        }
        
        guard password == confirmPassword else {
            onRegisterError?("Passwords do not match")
            return false
        }
        
        return true
    }
}
