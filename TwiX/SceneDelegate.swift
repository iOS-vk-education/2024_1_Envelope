import UIKit
import SwiftUI
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        window.addGestureRecognizer(tapGesture)
        
        if Auth.auth().currentUser != nil {
            let mainViewController = TabBarController()
            window.rootViewController = mainViewController
        } else {
            let authView = AuthenticationFlowView(onSuccess: { [weak self] in
                guard let self = self else { return }
                let mainViewController = TabBarController()
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = mainViewController
                }, completion: nil)
            })
            window.rootViewController = UIHostingController(rootView: authView)
        }
        
        UserSessionManager.shared.loadUserProfile()
        
        window.makeKeyAndVisible()
    }
    
    @objc func hideKeyboard() {
        window?.endEditing(true)
    }
}
