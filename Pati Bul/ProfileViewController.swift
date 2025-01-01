import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    var userAds: [AnimalAd] = []
    
    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()
    private let cityLabel = UILabel()
    private let phoneLabel = UILabel()
    private let emailLabel = UILabel()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profilim Ve İlanlarım"
        view.backgroundColor = .white
        
        setupUserInfoUI()
        setupTableView()
        setupLogoutButton()
        
        fetchUserData()
        fetchUserAds()
    }
    
    private func setupUserInfoUI() {
        let infoStackView = UIStackView(arrangedSubviews: [
            createInfoRow(title: "Ad:", label: nameLabel),
            createInfoRow(title: "Soyad:", label: surnameLabel),
            createInfoRow(title: "Şehir:", label: cityLabel),
            createInfoRow(title: "Telefon:", label: phoneLabel),
            createInfoRow(title: "E-posta:", label: emailLabel)
        ])
        infoStackView.axis = .vertical
        infoStackView.spacing = 8
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Çıkış Yap", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .red
        logoutButton.layer.cornerRadius = 10
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createInfoRow(title: String, label: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
    
    func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Kullanıcı verileri alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self.nameLabel.text = data["name"] as? String ?? "Ad bulunamadı"
                    self.surnameLabel.text = data["surname"] as? String ?? "Soyad bulunamadı"
                    self.cityLabel.text = data["city"] as? String ?? "Şehir bulunamadı"
                    self.phoneLabel.text = data["phone"] as? String ?? "Telefon bulunamadı"
                    self.emailLabel.text = data["email"] as? String ?? "E-posta bulunamadı"
                }
            }
        }
    }
    
    func fetchUserAds() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let collections = ["cats", "dogs"]
        userAds.removeAll()
        
        for collectionName in collections {
            db.collection("animals").document(collectionName).collection(collectionName)
                .whereField("userID", isEqualTo: userID)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("\(collectionName) koleksiyonunda hata oluştu: \(error.localizedDescription)")
                        return
                    }
                    guard let documents = snapshot?.documents else { return }
                    let ads = documents.map { doc -> AnimalAd in
                        let data = doc.data()
                        return AnimalAd(
                            id: doc.documentID,
                            type: collectionName,
                            ownerName: data["ownerName"] as? String ?? "",
                            ownerSurname: data["ownerSurname"] as? String ?? "",
                            city: data["city"] as? String ?? "",
                            phone: data["phone"] as? String ?? "",
                            age: data["age"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            animalType: data["animalType"] as? String ?? "",
                            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                        )
                    }
                    DispatchQueue.main.async {
                        self.userAds = ads
                        self.userAds.sort { $0.createdAt > $1.createdAt }
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: userAds[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let adToDelete = userAds[indexPath.row]

            // Kullanıcıdan silme işlemi için onay iste
            let alert = UIAlertController(title: "İlanı Sil", message: "Bu ilanı silmek istediğinizden emin misiniz?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { [weak self] _ in
                guard let self = self else { return }
                
                // Firestore'dan ilanı sil
                self.db.collection("animals")
                    .document(adToDelete.type)
                    .collection(adToDelete.type)
                    .document(adToDelete.id)
                    .delete { error in
                        if let error = error {
                            print("İlan silinirken hata oluştu: \(error.localizedDescription)")
                            return
                        }
                        DispatchQueue.main.async {
                            // Veri kaynağını ve tabloyu güncelle
                            if indexPath.row < self.userAds.count {
                                self.userAds.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .automatic)
                                print("İlan başarıyla silindi.")
                            }
                        }
                    }
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAd = userAds[indexPath.row]
        performSegue(withIdentifier: "toPetAdoptionVC", sender: selectedAd)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPetAdoptionVC",
           let destinationVC = segue.destination as? PetAdoptionViewController,
           let selectedAd = sender as? AnimalAd {
            destinationVC.animalAd = selectedAd
        }
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "Çıkış Yap", message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Tamam", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toLoginVc", sender: nil)
            } catch let signOutError {
                print("Çıkış yapılamadı: \(signOutError.localizedDescription)")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
