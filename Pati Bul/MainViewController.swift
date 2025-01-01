

import UIKit
import FirebaseFirestore

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let db = Firestore.firestore()
    var animalAds: [AnimalAd] = [] // Animal.swift dosyasındaki model
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // TableView setup
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupLayout()
        fetchAnimalAds()
    }
    
    // Firestore'dan ilanları dinleme ve güncelleme
    func fetchAnimalAds() {
        let collections = ["cats", "dogs"]
        animalAds.removeAll() // Mevcut listeyi temizle
        
        for collectionName in collections {
            db.collection("animals").document(collectionName).collection(collectionName).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("\(collectionName) koleksiyonunda hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("\(collectionName) koleksiyonunda belge bulunamadı.")
                    return
                }
                
                // Gelen verileri güncelle
                let updatedAds = documents.map { doc -> AnimalAd in
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
                    // Koleksiyona ait eski ilanları kaldır ve yeni ilanları ekle
                    self.animalAds = self.animalAds.filter { $0.type != collectionName } + updatedAds
                    
                    // İlanları tarihe göre sırala (en yeni üstte)
                    self.animalAds.sort { $0.createdAt > $1.createdAt }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // TableView Veri Kaynağı
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: animalAds[indexPath.row])
        return cell
    }
    
    // TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAd = animalAds[indexPath.row]
        performSegue(withIdentifier: "toPetAdoptionVc", sender: selectedAd)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Segue ile veri aktarımı
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPetAdoptionVc",
           let destinationVC = segue.destination as? PetAdoptionViewController,
           let selectedAd = sender as? AnimalAd {
            destinationVC.animalAd = selectedAd
        }
    }
    
    // TableView layout ayarları
    func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
