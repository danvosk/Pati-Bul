

import UIKit

class PetAdoptionViewController: UIViewController {

    // Seçilen ilan bilgisi
    var animalAd: AnimalAd?
    
    // Kart görünümü için bir UIView
    let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        return view
    }()
    
    // Bilgileri göstermek için bir stack view
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(cardView)
        cardView.addSubview(stackView)
        
        setupLayout()
        displayDetails()
    }
    
    // Detayları ekrana yazdırma
    func displayDetails() {
        guard let ad = animalAd else { return }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        // Detayları stack view'e ekle
        addDetailToStackView(title: "Hayvan Türü:", value: ad.animalType)
        addDetailToStackView(title: "Sahibi:", value: "\(ad.ownerName) \(ad.ownerSurname)")
        addDetailToStackView(title: "Şehir:", value: ad.city)
        addDetailToStackView(title: "Telefon:", value: ad.phone)
        addDetailToStackView(title: "Yaş:", value: ad.age)
        addDetailToStackView(title: "Açıklama:", value: ad.description)
        addDetailToStackView(title: "Oluşturulma Zamanı:", value: formatter.string(from: ad.createdAt))
    }
    
    // Yardımcı fonksiyon: Bir başlık ve değeri stack view'e ekle
    func addDetailToStackView(title: String, value: String) {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        titleLabel.text = title
        
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        valueLabel.textColor = .black
        valueLabel.text = value
        valueLabel.numberOfLines = 0
        
        let container = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        container.axis = .vertical
        container.spacing = 4
        stackView.addArrangedSubview(container)
    }
    
    // Layout ayarları
    func setupLayout() {
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20)
        ])
    }
}
