import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded(User)
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let userService: UserServiceProtocol
    private let authService: AuthServiceProtocol
    private var loadTask: Task<Void, Never>?
    private var updateTask: Task<Void, Never>?
    private var logoutTask: Task<Void, Never>?
    
    init(userService: UserServiceProtocol, authService: AuthServiceProtocol) {
        self.userService = userService
        self.authService = authService
    }
    
    func loadProfile(userId: String) {
        loadTask?.cancel()
        
        loadTask = Task {
            state = .loading
            
            do {
                let user = try await userService.getUserDetailsByUserId(userId: userId)
                guard !Task.isCancelled else { return }
                state = .loaded(user)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func updateProfile(userId: String, firstName: String, lastName: String, profilePictureUrl: String?) {
        updateTask?.cancel()
        
        updateTask = Task {
            state = .loading
            
            do {
                let model = UpdateProfileInformationModel(firstName: firstName, lastName: lastName, profilePictureUrl: profilePictureUrl)
                try await userService.updateProfileInformation(userId: userId, model)
                let user = try await userService.getUserDetailsByUserId(userId: userId)
                guard !Task.isCancelled else { return }
                state = .loaded(user)
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func logout() {
        logoutTask?.cancel()
        
        logoutTask = Task {
            do {
                try await authService.logout()
                guard !Task.isCancelled else { return }
                state = .idle
            } catch {
                guard !Task.isCancelled else { return }
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func cancelAllOperations() {
        loadTask?.cancel()
        updateTask?.cancel()
        logoutTask?.cancel()
    }
}
