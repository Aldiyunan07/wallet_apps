# E-Wallet Application

## Deskripsi
Aplikasi e-wallet ini memungkinkan pengguna untuk melakukan top-up, withdraw, dan transfer. Aplikasi ini menggunakan API dari [walletjwtapi.000webhostapp.com](http://walletjwtapi.000webhostapp.com) untuk menangani operasi keuangan.

## Fitur
- **Top-up**: Pengguna dapat mengisi saldo e-wallet mereka.
- **Withdraw**: Pengguna dapat menarik saldo dari e-wallet mereka ke rekening bank.
- **Transfer**: Pengguna dapat mentransfer saldo ke pengguna e-wallet lain.
- **Login**: Pengguna dapat masuk ke akun sendiri.
- **Riwayat Transaksi**: Pengguna dapat melihat riwayat transaksi, dan riwayat transfer.

## Kelompok 5
- **Aldi Yunan Anwari**
- **Gumilar Ichsanulhaq**
- **Paschal Hendryawan**

## Prasyarat
- Flutter SDK
- Android Studio atau Visual Studio Code dengan ekstensi Flutter
- PHP dan Composer (untuk API Laravel)

## Instalasi
### Aplikasi Flutter
1. Clone repository ini
    ```bash
    git clone https://github.com/username/ewallet-app.git
    ```
2. Pindah ke direktori proyek
    ```bash
    cd ewallet-app
    ```
3. Instal dependensi
    ```bash
    flutter pub get
    ```

## Package yang Diinstal
- **Cupertino Icons ^1.0.6** : Ikon untuk aplikasi iOS.
- **Http ^1.2.1** : Melakukan request HTTP.
- **Shared Preferences ^2.2.3** : Menyimpan data sederhana secara lokal.
- **Intl ^0.17.0** : Internasionalisasi dan format tanggal/angka.
- **Google Fonts ^6.2.1** : Menggunakan font dari Google Fonts.

## Catatan
Jika terdapat kesalahan dalam menyambungkan ke server API di [walletjwtapi.000webhostapp.com](http://walletjwtapi.000webhostapp.com), maka Anda dapat menggunakan API lokal yang tersedia di GitHub dengan langkah-langkah yang dijelaskan di bawah ini.


### API Laravel
1. Clone repository API
    ```bash
    git clone https://github.com/Aldiyunan07/wallet_api.git
    ```
2. Pindah ke direktori proyek API
    ```bash
    cd wallet_api
    ```
3. Instal dependensi
    ```bash
    composer install
    ```
4. Salin file `.env.example` menjadi `.env`
    ```bash
    cp .env.example .env
    ```
5. Generate key aplikasi Laravel
    ```bash
    php artisan key:generate
    ```
6. Konfigurasi database di file `.env`
7. Migrasi database
    ```bash
    php artisan migrate
    ```
8. Jalankan server API lokal
    ```bash
    php artisan serve
    ```

## Penggunaan
1. Jalankan aplikasi Flutter
    ```bash
    flutter run
    ```

2. Akses aplikasi di emulator atau perangkat fisik.
