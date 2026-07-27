# 🐑 GoSheep Mobile

Aplikasi mobile untuk sistem GoSheep yang membantu peternak mengelola data domba, mencatat kesehatan dan berat, memantau reproduksi, serta mengakses fitur berbasis AI. Aplikasi ini dibangun dengan Flutter dan terhubung ke backend API.

## Ringkasan Aplikasi

Proyek ini menyediakan fitur seperti:

- Autentikasi pengguna
- Manajemen data domba, kandang, dan ras
- Pencatatan berat badan dan kesehatan
- Monitoring perkawinan, kehamilan, dan kelahiran
- Scan eartag menggunakan OCR (Google ML Kit)
- Tampilan dashboard dan laporan

## Teknologi yang Digunakan

- Flutter + Dart
- Provider untuk state management
- Dio untuk komunikasi API
- flutter_secure_storage untuk menyimpan token auth
- Google ML Kit untuk OCR
- camera dan image_picker untuk input media

## Struktur Proyek

```text
lib/
├── core/          # tema, util, widget umum
├── data/          # api client, model, provider, service
├── features/      # halaman dan fitur aplikasi
├── routes/        # definisi route aplikasi
└── main.dart      # entry point aplikasi
```

## Persyaratan Sistem

Sebelum menjalankan aplikasi, pastikan perangkat Anda sudah memiliki:

- Flutter SDK 3.9+ terinstal
- Android Studio / VS Code dengan plugin Flutter
- Emulator Android, perangkat fisik, atau browser Chrome
- Backend API yang sudah berjalan

## Instalasi

1. Clone repository:

```bash
git clone https://github.com/Vioni16/GoSheep-Mobile.git
cd gosheep_mobile
```

2. Install dependency:

```bash
flutter pub get
```

3. Cek environment Flutter:

```bash
flutter doctor
```

4. Jalankan aplikasi:

```bash
flutter run
```

## Setup Backend/API

Aplikasi ini mengirim request ke backend melalui file API client. Base URL default saat ini sudah diatur di file [lib/data/api_client.dart](lib/data/api_client.dart), tetapi Anda bisa mengubahnya saat runtime lewat argument `--dart-define`.

### Contoh konfigurasi base URL

Jika ingin mengubah URL backend langsung di file API client, Anda bisa menyesuaikan bagian berikut di [lib/data/api_client.dart](lib/data/api_client.dart):

```dart
class ApiClient {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://19.321.98.123:8000/api',
  );

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
}
```

Contoh perubahan manual jika ingin memakai URL lain:

```dart
defaultValue: 'http://21.543.12.345:8000/api'
```

#### Untuk emulator Android

```bash
flutter run --dart-define=API_BASE_URL=http://21.543.12.345:8000/api
```

#### Untuk perangkat fisik

Gunakan IP laptop/PC Anda, misalnya:

```bash
flutter run --dart-define=API_BASE_URL=http:///21.543.12.345:8000/api
```

#### Untuk production/staging

```bash
flutter run --dart-define=API_BASE_URL=https://api.gosheep.example.com/api
```

> Jika backend Anda berjalan di web dan menggunakan CORS, pastikan server mengizinkan origin dari localhost atau domain yang Anda gunakan.

## Instalasi untuk Release

### Android (release APK / AAB)

Build APK release:

```bash
flutter build apk --release
```

Build App Bundle release:

```bash
flutter build appbundle --release
```

File hasil build akan tersedia di:

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

Jika ingin menjalankan versi release di emulator atau perangkat:

```bash
flutter install
```

Atau langsung jalankan release build:

```bash
flutter run --release
```

## Catatan Penting

- Jika Anda menjalankan di browser, gunakan `localhost` atau domain yang sesuai.
- Pastikan backend sudah menyediakan endpoint API yang dipakai oleh aplikasi dan mengembalikan format JSON.

## Troubleshooting Singkat

- Jika terjadi error `SocketException` atau koneksi gagal, cek:
  - URL base API sudah benar
  - Backend sedang berjalan
  - Port yang digunakan sesuai
  - CORS sudah diatur untuk web

## Kontribusi

Jika ingin mengembangkan fitur baru, silakan buat branch terpisah sebelum melakukan pull request.
