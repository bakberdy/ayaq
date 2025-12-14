import Foundation

final class ForgotPasswordViewModel {
    var email: String = ""
    
    var onSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func requestPasswordReset() {
        guard validateInput() else { return }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            self?.onSuccess?()
        }
    }
    
    private func validateInput() -> Bool {
        guard !email.isEmpty else {
            onError?("Email cannot be empty")
            return false
        }
        
        guard EmailValidator.isValid(email) else {
            onError?("Please enter a valid email")
            return false
        }
        
        return true
    }
}
