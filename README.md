# SpaceNews Core

Advanced International News Portal — aplikasi Flutter yang menampilkan berita
antariksa internasional terbaru menggunakan **Spaceflight News API v4**,
dengan autentikasi & penyimpanan data melalui **Firebase Authentication**,
**Cloud Firestore**, dan sesi lokal via **SharedPreferences**.

---

## ✅ Pemenuhan Spesifikasi

| # | Halaman | File | Catatan |
|---|---------|------|---------|
| 1 | Splash Screen & Session Handling | `lib/screens/splash/splash_screen.dart` | Delay tepat 3 detik, cek sesi via `SharedPreferences` |
| 2 | Halaman Daftar | `lib/screens/auth/register_screen.dart` | Logo, Nama, Email, Password, tombol Daftar + link Login |
| 3 | Forgot Password | `lib/screens/auth/forgot_password_screen.dart` | Email + tombol "Send to email" via `FirebaseAuth.sendPasswordResetEmail` |
| 4 | Login | `lib/screens/auth/login_screen.dart` | Logo, Email, Password, "Forgot Password?", "Login" |
| 5 | Welcome Page | `lib/screens/welcome/welcome_screen.dart` | Teks sambutan + ilustrasi jurnalisme (lihat catatan di bawah) |
| 6 | Home Page | `lib/screens/home/home_screen.dart` + `lib/screens/main_navigation/main_navigation.dart` | BottomNavigationBar 4 menu, headline banner + list berita dinamis |
| 7 | Detail Page | `lib/screens/detail/detail_screen.dart` | Foto besar, judul, publisher, summary, ikon hati di AppBar, tombol Back |
| 8 | Halaman Favorite | `lib/screens/favorite/favorite_screen.dart` | Stream real-time dari koleksi Firestore `favorites` |
| 9 | Halaman Notifikasi | `lib/screens/notification/notification_screen.dart` | Feed urut berdasarkan tanggal publikasi terbaru |
| 10 | Halaman Profile | `lib/screens/profile/profile_screen.dart` | Data dinamis dari Firestore `users`, tombol Edit Profile, tombol Log Out → kembali ke Halaman Daftar |
| 11 | Edit Profile | `lib/screens/profile/edit_profile_screen.dart` | Ubah Nama Lengkap & Instagram; Email read-only (terikat ke Firebase Auth) |

**Arsitektur data**: `lib/services/auth_service.dart` (Firebase Auth),
`lib/services/firestore_service.dart` (Cloud Firestore), `lib/services/session_service.dart`
(SharedPreferences), `lib/services/news_api_service.dart` (REST API).

---

## 📌 Catatan Penting tentang Gambar

- **Logo aplikasi**: diambil dari gambar Freepik (keyword *"e-commerce"*) yang
  Anda unggah, disimpan di `assets/images/logo.png`.
- **Ilustrasi Welcome Page**: dibuat sebagai vector illustration kustom
  langsung di Flutter (`lib/widgets/space_journalism_illustration.dart`,
  tema satelit + koran) alih-alih menyematkan link foto stok pihak ketiga.
  Ini dilakukan agar aplikasi **tidak bergantung pada lisensi gambar
  berbayar/hak cipta pihak lain** dan tetap tampil meski tanpa koneksi
  internet. Jika rubrik tugas Anda mewajibkan gambar dari internet secara
  literal, Anda bisa dengan mudah menggantinya — tinggal ganti
  `SpaceJournalismIllustration(...)` pada `welcome_screen.dart` dengan
  `Image.network('URL_GAMBAR_ANDA')`.

---

## 🛠️ Persiapan Sebelum Menjalankan

Project ini sudah terhubung ke Firebase project **`pab-remidi237`** —
folder native `android/`, `ios/`, `lib/firebase_options.dart`,
`firebase.json`, `.firebaserc`, `firestore.rules`, dan
`firestore.indexes.json` semuanya sudah disertakan dan dikonfigurasi.
Untuk menjalankan di komputer Anda:

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Jalankan aplikasi
```bash
flutter run
```

### Kalau ingin menghubungkan ke project Firebase Anda sendiri
```bash
npm install -g firebase-tools
firebase login

dart pub global activate flutterfire_cli
flutterfire configure
```
`flutterfire configure` akan **menimpa** `lib/firebase_options.dart` dengan
konfigurasi project Firebase Anda. Setelah itu, aktifkan layanan berikut
di Firebase Console:
- **Authentication** → Sign-in method → aktifkan **Email/Password**.
- **Firestore Database** → buat database (mis. via
  `firebase firestore:databases:create "(default)" --location=asia-southeast2`),
  lalu deploy aturan keamanan yang sudah disediakan:
  ```bash
  firebase deploy --only firestore --project <project-id-anda>
  ```

---

## 📂 Struktur Folder

```
lib/
├── main.dart                      # Entry point + route table
├── firebase_options.dart          # Konfigurasi Firebase project pab-remidi237
├── models/
│   ├── article.dart                # Model artikel dari Spaceflight News API
│   ├── app_user.dart                # Model profil pengguna (Firestore "users")
│   └── favorite_article.dart        # Model item favorit (Firestore "favorites")
├── services/
│   ├── auth_service.dart            # Firebase Authentication
│   ├── firestore_service.dart       # Cloud Firestore (users & favorites)
│   ├── news_api_service.dart        # REST API Spaceflight News v4
│   └── session_service.dart         # SharedPreferences (sesi login lokal)
├── screens/
│   ├── splash/splash_screen.dart
│   ├── welcome/welcome_screen.dart
│   ├── auth/
│   │   ├── register_screen.dart
│   │   ├── login_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── main_navigation/main_navigation.dart   # BottomNavigationBar 4 tab
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/headline_banner.dart, news_card.dart
│   ├── detail/detail_screen.dart
│   ├── favorite/favorite_screen.dart
│   ├── notification/notification_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       └── edit_profile_screen.dart      # Edit Nama Lengkap & Instagram
├── widgets/                        # Komponen UI yang dipakai ulang
│   ├── app_text_field.dart
│   ├── primary_button.dart
│   └── space_journalism_illustration.dart
└── utils/
    ├── app_colors.dart
    ├── app_routes.dart
    └── app_snackbar.dart

firebase.json            # Config Firestore rules/indexes + FlutterFire
.firebaserc              # Default Firebase project (pab-remidi237)
firestore.rules          # Aturan keamanan Firestore (sudah di-deploy)
firestore.indexes.json   # Composite index Firestore (kosong, belum dibutuhkan)
```

---

## 🔄 Alur Navigasi

```
Splash (3s, cek SharedPreferences)
   ├── sudah login  → MainNavigation (Home)
   └── belum login  → Welcome
                          ├── "Mulai Sekarang" → Login → (Forgot Password)
                          └── "Belum punya akun? Daftar" → Register

Register / Login berhasil → simpan sesi → MainNavigation (Home)

MainNavigation (BottomNavigationBar)
   ├── Home          → tap berita → Detail (toggle favorit ke Firestore)
   ├── Favorite       → real-time dari Firestore → tap → fetch detail by id → Detail
   ├── Notification   → feed urut dari API
   └── Profile        → data dari Firestore
                            ├── Edit Profile → ubah Nama Lengkap & Instagram → simpan ke Firestore
                            └── Log Out → bersihkan sesi → Register
```

---

## 🌐 REST API yang Digunakan

```
GET https://api.spaceflightnewsapi.net/v4/articles/?limit=20
GET https://api.spaceflightnewsapi.net/v4/articles/{id}/
```

API ini publik dan tidak memerlukan API key.

---

## ⚠️ Known Limitations

- Widget test yang ada (`test/widget_test.dart`) hanya smoke test
  sederhana (memastikan `SpaceNewsCoreApp` bisa di-build tanpa crash) —
  belum ada test untuk setiap layar/fitur secara individual.
- `firestore.indexes.json` masih kosong; tambahkan composite index di
  sana bila nanti ada query Firestore baru yang membutuhkannya.
