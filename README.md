# Pati Bul Uygulaması 🐾

**Pati Bul**, evcil hayvan sahiplenmek isteyen kullanıcılarla, sahiplenilmek üzere ilan verilmiş evcil hayvanları buluşturan bir mobil uygulamadır. Uygulama, hayvanların barınaklardan veya bireylerden kolayca sahiplenilebilmesini sağlamayı amaçlar.

---

## 📋 Projenin Amacı

Bu proje, sokakta veya barınakta bulunan hayvanların daha hızlı ve kolay bir şekilde yeni bir yuva bulabilmesini sağlamak amacıyla geliştirilmiştir. Kullanıcılar, uygulama sayesinde hayvanların özelliklerini inceleyebilir, kendi ilanlarını ekleyebilir ve sahiplenmek istedikleri hayvanlarla ilgili detaylı bilgilere ulaşabilir.

---

## 🚀 Özellikler

- **Giriş ve Kayıt:**
  - Firebase Authentication ile kullanıcı kimlik doğrulama.
  - Kolay ve hızlı kullanıcı kaydı.

- **İlanlar:**
  - Tüm hayvan ilanlarını listeleme.
  - Detaylı ilan görüntüleme.
  - Yeni ilan ekleyerek kedi veya köpek sahiplenmek isteyen kişilere ulaşma.

- **Profil Yönetimi:**
  - Kullanıcının profil bilgilerini görüntüleme.
  - Kullanıcının eklediği ilanları listeleme ve düzenleme.

- **Özel Hücre Tasarımları:**
  - İlanlar ve hayvanlar için özelleştirilmiş CollectionView ve TableView tasarımları.

---

## 📱 Kullanılan Teknolojiler ve Kütüphaneler

### **Frontend:**
- **Swift:** iOS için modern ve hızlı programlama dili.
- **UIKit:** Kullanıcı arayüzü bileşenleri ve animasyonlar.

### **Backend:**
- **Firebase Authentication:** Kullanıcı giriş/kayıt işlemleri.
- **Firestore Database:** İlan ve kullanıcı verilerinin yönetimi.

---

## 📂 Proje Yapısı

- **Model:**
  - `Animal.swift`: Hayvanların tür, yaş, şehir gibi özelliklerini içeren veri modeli.
  
- **View Controllers:**
  - `LoginViewController.swift`: Kullanıcı giriş ekranı.
  - `RegisterViewController.swift`: Kullanıcı kayıt ekranı.
  - `MainViewController.swift`: Anasayfa, tüm ilanların listelendiği ekran.
  - `PetAdoptionViewController.swift`: Seçilen ilanın detaylarının gösterildiği ekran.
  - `AddAnimalViewController.swift`: Yeni ilan ekleme ekranı.
  - `ProfileViewController.swift`: Kullanıcı profili ve ilanları yönetim ekranı.
  
- **Custom Views:**
  - `CustomTableViewCell.swift`: İlanlar için özel TableView hücre tasarımı.
  - `CustomCollectionViewCell.swift`: Hayvanlar için özel CollectionView hücre tasarımı.

---

## 📷 Ekran Görselleri

### Anasayfa
![Anasayfa](Pati%20Bul/Assets.xcassets/anasayfa.imageset/1x.png)

### Giriş
![Giriş](Pati%20Bul/Assets.xcassets/giris.imageset/1x.png)

### İlan
![İlan](Pati%20Bul/Assets.xcassets/ilan.imageset/1x.png)

### Profil
![Profil](Pati%20Bul/Assets.xcassets/profil.imageset/1x.png)
