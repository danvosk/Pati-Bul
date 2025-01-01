import UIKit

class AddAnimalViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Hayvan türleri: Görsel ismi ve tür ismi
    let animals = [
        ("kedi", "Kedi"),
        ("kopek", "Köpek")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate ve DataSource ayarları
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Kaydırmayı kapat
        collectionView.isScrollEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hücre seçim durumunu sıfırla
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                collectionView.deselectItem(at: indexPath, animated: false)
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.contentView.backgroundColor = UIColor.white
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AddAnimalViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalsCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // Hücreye verileri ata
        let animal = animals[indexPath.row]
        cell.animalImage.image = UIImage(named: animal.0)
        cell.animalName.text = animal.1
        cell.contentView.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 2
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // Geçici renk değişimi
        cell.contentView.backgroundColor = UIColor.lightGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        // Segue işlemi
        performSegue(withIdentifier: "toAnimalDetailsVC", sender: indexPath)
    }
    
    // Segue hazırlığı
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnimalDetailsVC",
           let indexPath = sender as? IndexPath,
           let detailsVC = segue.destination as? AnimalDetailsViewController {
            // Seçilen hayvan türünü aktar
            detailsVC.selectedAnimalType = animals[indexPath.row].1
        }
    }
}
