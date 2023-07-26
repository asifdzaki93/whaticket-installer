#!/bin/bash

#######################################
# Fungsi: print_banner
# Argumen: None
#######################################
print_banner() {
  # Fungsi ini bisa diisi dengan tampilan banner atau teks lainnya
  # Sesuaikan dengan preferensi Anda
  echo "======================================="
}

#######################################
# Fungsi: get_frontend_url
# Argumen: None
#######################################
get_frontend_url() {
  print_banner
  printf "${WHITE} 💻 Masukkan URL frontend:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_url
}

#######################################
# Fungsi: get_backend_url
# Argumen: None
#######################################
get_backend_url() {
  print_banner
  printf "${WHITE} 💻 Masukkan URL backend API:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_url
}

#######################################
# Fungsi: get_urls
# Argumen: None
#######################################
get_urls() {
  get_frontend_url
  get_backend_url
}

#######################################
# Fungsi: software_update
# Argumen: None
#######################################
software_update() {
  frontend_update
  backend_update
}

#######################################
# Fungsi: inquiry_options
# Argumen: None
#######################################
inquiry_options() {
  print_banner
  printf "${WHITE} 💻 Apa yang perlu Anda lakukan?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Instalasi\n"
  printf "   [2] Pembaruan\n"
  printf "\n"
  read -p "> " option

  case "${option}" in
    1) get_urls ;;

    2) 
      software_update 
      exit
      ;;

    *) exit ;;
  esac
}

# Panggil fungsi untuk menanyakan URL frontend dan backend API
inquiry_options

# Setelah mendapatkan URL frontend dan backend API, Anda dapat melanjutkan dengan implementasi fungsi lainnya sesuai kebutuhan.
# Misalnya, Anda dapat membuat fungsi frontend_update dan backend_update untuk melakukan pembaruan perangkat lunak pada masing-masing bagian.
# Setelah semua implementasi fungsi selesai, Anda bisa menambahkan tindakan terakhir atau pesan keluaran yang sesuai.
# Selamat mengimplementasikan skrip shell sesuai kebutuhan Anda!

