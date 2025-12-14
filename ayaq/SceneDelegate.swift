import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("🔵 SceneDelegate: scene will connect")
        guard let windowScene = (scene as? UIWindowScene) else {
            print("🔴 Failed to get windowScene")
            return
        }
        
        print("🔵 Creating window and view controller")
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
        let rootViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        print("🔵 Window setup complete in SceneDelegate")
        print("🔵 Window frame: \(window?.frame ?? .zero)")
    }
}
