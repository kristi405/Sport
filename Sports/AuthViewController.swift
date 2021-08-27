import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    private var isUserExist = false {
        willSet {
            if newValue {
                titleLable.text = "Вход"
                nameTF.isHidden = true
                enterButton.setTitle("Зарегистрироваться", for: .normal)
            } else {
                titleLable.text = "Регистрация"
                nameTF.isHidden = false
                enterButton.setTitle("Войти", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
        isUserExist = !isUserExist
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let name = nameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        
        if !isUserExist {
            if (name != nil && email != nil && password != nil) {
                guard let userName = name, let userEmail = email, let userPassword = password else {return true}
                Auth.auth().createUser(withEmail: userEmail, password: userPassword) { result, error in
                    if error == nil {
                        print(result!)
                        guard let result = result else {return}
                        let ref = Database.database().reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name": userName, "email": userEmail])
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                showAlert()
            }
        } else {
            if (email != nil && password != nil) {
                guard let userEmail = email, let userPassword = password else {return true}
                Auth.auth().signIn(withEmail: userEmail, password: userPassword) { result, error in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                showAlert()
            }
        }
        
        return true
    }
}

