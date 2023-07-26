### Alat Interaktif CLI untuk Menginstal dan Memperbarui Whaticket

### Unduh & Persiapan

Pertama, Anda perlu mengunduhnya:

```bash
sudo apt -y update && apt -y upgrade
sudo apt install -y git
git clone https://github.com/asifdzaki93/whaticket-installer.git
```

Sekarang, yang perlu Anda lakukan adalah membuatnya dapat dieksekusi:

```bash
sudo chmod +x ./whaticket-installer/whaticket
```

### Penggunaan

Setelah mengunduh dan memberinya izin eksekusi, Anda perlu **masuk ke** direktori installer dan **jalankan skrip dengan sudo**:

```bash
cd ./whaticket-installer
```

```bash
sudo ./whaticket
```

Dengan melakukan langkah-langkah di atas, Anda akan dapat menggunakan alat ini untuk menginstal dan memperbarui Whaticket dengan antarmuka baris perintah yang interaktif. Selamat mencoba!
