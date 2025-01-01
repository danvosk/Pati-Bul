//
//  AnimalDetailsViewController.swift
//  Pati Bul
//
//  Created by Görkem Karagöz on 11.12.2024.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth

class AnimalDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    var selectedAnimalType: String?
    let catBreeds = ["British Shorthair", "Scottish Fold", "İran Kedisi", "Maine Coon", "Van Kedisi", "Norveç Orman Kedisi", "Ragdoll", "Chinchilla", "Tekir (Tabby)", "Ankara Kedisi"]
    let dogBreeds = ["Golden Retriever", "Labrador Retriever", "German Shepherd", "Pomeranian", "Bulldog", "Siberian Husky", "Dachshund", "Shih Tzu", "Rottweiler", "Akbaş", "Kangal Köpeği"]
    var animalBreeds: [String] = []
    
    let nameTextField: UITextField = createTextField(placeholder: "İlan Sahibinin Adı")
    let surnameTextField: UITextField = createTextField(placeholder: "İlan Sahibinin Soy Adı")
    let animalTypeTextField: UITextField = createTextField(placeholder: "Hayvan Türü")
    let cityTextField: UITextField = createTextField(placeholder: "Şehir")
    let phoneNumberTextField: UITextField = {
        let textField = createTextField(placeholder: "Telefon Numarası")
        textField.keyboardType = .phonePad
        textField.text = "+90"
        return textField
    }()
    let ageTextField: UITextField = createTextField(placeholder: "Yaş")
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .lightGray
        textView.text = "Açıklama"
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    let adoptAnimalButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Hayvanı Sahiplendir", for: .normal)
        button.backgroundColor = .systemMint
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.addTarget(nil, action: #selector(adoptAnimalButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let animalTypePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UI Elemanlarını Ekle
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(animalTypeTextField)
        view.addSubview(cityTextField)
        view.addSubview(phoneNumberTextField)
        view.addSubview(ageTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(adoptAnimalButton)
        
        // Picker Ayarları
        animalTypePicker.delegate = self
        animalTypePicker.dataSource = self
        animalTypeTextField.inputView = animalTypePicker
        
        // Delegate Ayarları
        descriptionTextView.delegate = self
        phoneNumberTextField.delegate = self
        
        // Seçilen hayvan türüne göre alt türleri belirle
        if selectedAnimalType == "Kedi" {
            animalBreeds = catBreeds
        } else if selectedAnimalType == "Köpek" {
            animalBreeds = dogBreeds
        }
        
        setupLayout()
    }
    
    @objc func adoptAnimalButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let surname = surnameTextField.text, !surname.isEmpty,
              let animalType = animalTypeTextField.text, !animalType.isEmpty,
              let city = cityTextField.text, !city.isEmpty,
              let phone = phoneNumberTextField.text, !phone.isEmpty,
              let age = ageTextField.text, !age.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty, description != "Açıklama" else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }
        
        let collectionName = selectedAnimalType == "Kedi" ? "cats" : "dogs"
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert(title: "Hata", message: "Kullanıcı oturum açmamış.")
            return
        }

        let animalData: [String: Any] = [
            "ownerName": name,
            "ownerSurname": surname,
            "animalType": animalType,
            "city": city,
            "phone": phone,
            "age": age,
            "description": description,
            "userID": userID,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("animals").document(collectionName).collection(collectionName).addDocument(data: animalData) { error in
            if let error = error {
                self.showAlert(title: "Hata", message: "Veritabanına eklenirken bir hata oluştu: \(error.localizedDescription)")
            } else {
                self.showAlert(title: "Başarılı", message: "Hayvan sahiplendirme ilanı başarıyla oluşturuldu!")
                
                // Tüm TextField ve TextView'ları temizle
                self.nameTextField.text = ""
                self.surnameTextField.text = ""
                self.animalTypeTextField.text = ""
                self.cityTextField.text = ""
                self.phoneNumberTextField.text = "+90"
                self.ageTextField.text = ""
                self.descriptionTextView.text = "Açıklama"
                self.descriptionTextView.textColor = .lightGray
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Açıklama"
            textView.textColor = .lightGray
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animalBreeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return animalBreeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        animalTypeTextField.text = animalBreeds[row]
        view.endEditing(true)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            surnameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            surnameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            animalTypeTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 10),
            animalTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            animalTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            animalTypeTextField.heightAnchor.constraint(equalToConstant: 40),
            cityTextField.topAnchor.constraint(equalTo: animalTypeTextField.bottomAnchor, constant: 10),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            phoneNumberTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            ageTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),
            descriptionTextView.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            adoptAnimalButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            adoptAnimalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            adoptAnimalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            adoptAnimalButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        return textField
    }
}
