

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var mailTextField: UITextField! // E-posta giriş alanı
    @IBOutlet weak var passwordTextField: UITextField! // Kullanıcı parolasını girecek

    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        // Kullanıcı giriş bilgilerini kontrol et
        guard let email = mailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen e-posta ve şifreyi doldurun.")
            return
        }
        
        // Firebase Authentication ile kullanıcı giriş işlemi
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Hata", message: "Giriş başarısız: \(error.localizedDescription)")
                return
            }
            
            // Giriş başarılı
            self.showAlert(title: "Başarılı", message: "Giriş başarılı!") {
                self.performSegue(withIdentifier: "goToMainVc", sender: nil)
            }
        }
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToRegisterVc", sender: nil)
    }
    
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?() // "Tamam" butonuna basıldığında çalışacak kod
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
