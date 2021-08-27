import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}
