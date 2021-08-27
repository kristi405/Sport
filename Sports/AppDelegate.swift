import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.showModalAuth()
            }
        }
        return true
    }
    
    func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authViewController = storyboard.instantiateViewController(identifier: "AuthViewController") as? AuthViewController
        guard let authVC = authViewController else {return}
        self.window?.rootViewController?.present(authVC, animated: true, completion: nil)
    }
}

