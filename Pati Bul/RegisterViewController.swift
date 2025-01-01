

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.text = "+90"
        phoneNumberTextField.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            if range.location < 3 { return false }
            return newLength <= 13
        }
        return true
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToLoginVc", sender: nil)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {

        guard let name = nameTextField.text, !name.isEmpty,
              let surname = surnameTextField.text, !surname.isEmpty,
              let city = cityTextField.text, !city.isEmpty,
              let phoneInput = phoneNumberTextField.text, !phoneInput.isEmpty,
              let mail = mailTextField.text, !mail.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }

        let phone = phoneInput.hasPrefix("+90") ? phoneInput : "+90\(phoneInput)"

        // Firebase Authentication ile kullanıcı kaydı
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Hata", message: "Kayıt başarısız: \(error.localizedDescription)")
                return
            }

            // Kullanıcı başarıyla oluşturuldu, Firestore'a kayıt yapılıyor
            if let userId = authResult?.user.uid {
                self.db.collection("users").document(userId).setData([
                    "name": name,
                    "surname": surname,
                    "city": city,
                    "phone": phone,
                    "email": mail,
                    "createdAt": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        self.showAlert(title: "Hata", message: "Veritabanı hatası: \(error.localizedDescription)")
                        return
                    }

                    self.showAlert(title: "Başarılı", message: "Kayıt işlemi tamamlandı!")
                    
                    self.nameTextField.text = ""
                    self.surnameTextField.text = ""
                    self.cityTextField.text = ""
                    self.phoneNumberTextField.text = "+90"
                    self.mailTextField.text = ""
                    self.passwordTextField.text = ""
                    
               
                    self.performSegue(withIdentifier: "goToLoginVc", sender: nil)
                }
            }
        }
    }

   
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
