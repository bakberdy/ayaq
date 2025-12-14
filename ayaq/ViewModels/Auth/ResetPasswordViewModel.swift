import Foundation

final class ResetPasswordViewModel {
    var email: String = ""
    var code: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func resetPassword() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            self?.onSuccess?()
        }
    }
    
    private func validateInputs() -> Bool {
        guard !email.isEmpty else {
            onError?("Email cannot be empty")
            return false
        }
        
        guard EmailValidator.isValid(email) else {
            onError?("Please enter a valid email")
            return false
        }
        
        guard !code.isEmpty else {
            onError?("Verification code cannot be empty")
            return false
        }
        
        guard let codeInt = Int(code), codeInt > 0 else {
            onError?("Please enter a valid verification code")
            return false
        }
        
        guard !newPassword.isEmpty else {
            onError?("New password cannot be empty")
            return false
        }
        
        guard newPassword.count >= 6 else {
            onError?("Password must be at least 6 characters")
            return false
        }
        
        guard newPassword == confirmPassword else {
            onError?("Passwords do not match")
            return false
        }
        
        return true
    }
}
