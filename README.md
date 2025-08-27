# Skrip Instalasi Tema Pterodactyl

Ini adalah skrip otomatis untuk mempermudah instalasi berbagai tema populer untuk [Pterodactyl Panel](https://pterodactyl.io/). Skrip ini akan menangani dependensi seperti Node.js dan Blueprint (jika diperlukan) serta mengkonfigurasi tema yang Anda pilih secara otomatis.
## ✨ Fitur

-   **Instalasi Satu Perintah**: Cukup salin dan jalankan satu baris perintah untuk memulai.
-   **Menu Interaktif**: Antarmuka yang ramah pengguna untuk memilih tema yang diinginkan.
-   **Penanganan Dependensi Otomatis**: Skrip akan menginstal `Node.js`, `yarn`, `Blueprint`, dan dependensi lain yang diperlukan.
-   **Dukungan Multi-Tema**: Instal salah satu tema populer dengan mudah.

## 📋 Tema yang Didukung

Saat ini, skrip ini mendukung instalasi tema berikut:
-   **Nebula Theme**
-   **Elysium Theme**
-   **NookTheme**

## 🛑 Prasyarat

Sebelum menjalankan skrip, pastikan sistem Anda memenuhi persyaratan berikut:
-   Pterodactyl Panel `v1.x` sudah terinstal dan berfungsi.
-   Akses **root** atau pengguna dengan hak `sudo`.
-   Sistem Operasi: **Ubuntu** (22.04) atau **Debian** (12).

> **PENTING:** Selalu buat cadangan (backup) dari direktori `/var/www/pterodactyl` Anda sebelum menjalankan skrip ini. Penulis tidak bertanggung jawab atas kerusakan atau kehilangan data yang mungkin terjadi.

## 🚀 Instalasi Cepat (One-Liner)

Untuk memulai instalasi, cukup salin perintah di bawah ini dan jalankan di terminal server Anda. Skrip akan diunduh dan dieksekusi secara otomatis.

```bash
curl -sSL (https://raw.githubusercontent.com/alands-offc/theme/main/install.sh) | sudo bash
