#!/bin/bash
# 
# Manajemen sistem

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
# Fungsi: system_create_user
# Argumen: None
#######################################
system_create_user() {
  print_banner
  printf "${WHITE} 💻 Sekarang kita akan membuat pengguna untuk deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  useradd -m -p $(openssl passwd -crypt $deploy_password) -s /bin/bash -G sudo deploy
  usermod -aG sudo deploy
EOF

  sleep 2
}

#######################################
# Fungsi: system_git_clone
# Argumen: None
#######################################
system_git_clone() {
  print_banner
  printf "${WHITE} 💻 Mengunduh kode whaticket...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  git clone https://github.com/asifdzaki93/whatsapp-x-kasirvip.git /home/deploy/whaticket/
EOF

  sleep 2
}

#######################################
# Fungsi: system_update
# Argumen: None
#######################################
system_update() {
  print_banner
  printf "${WHITE} 💻 Sedang memperbarui sistem...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
EOF

  sleep 2
}

# Tambahkan implementasi fungsi lainnya sesuai kebutuhan Anda
# ...

# Contoh: Fungsi system_node_install
#######################################
# Fungsi: system_node_install
# Argumen: None
#######################################
system_node_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal Node.js...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  apt-get install -y nodejs
EOF

  sleep 2
}

# Contoh: Fungsi system_docker_install
#######################################
# Fungsi: system_docker_install
# Argumen: None
#######################################
system_docker_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal Docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y apt-transport-https \
                 ca-certificates curl \
                 software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

  apt install -y docker-ce
EOF

  sleep 2
}

# Contoh: Fungsi system_puppeteer_dependencies
#######################################
# Fungsi: system_puppeteer_dependencies
# Argumen: None
#######################################
system_puppeteer_dependencies() {
  print_banner
  printf "${WHITE} 💻 Menginstal dependensi puppeteer...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt-get install -y libxshmfence-dev \
                      libgbm-dev \
                      wget \
                      unzip \
                      fontconfig \
                      locales \
                      gconf-service \
                      libasound2 \
                      libatk1.0-0 \
                      libc6 \
                      libcairo2 \
                      libcups2 \
                      libdbus-1-3 \
                      libexpat1 \
                      libfontconfig1 \
                      libgcc1 \
                      libgconf-2-4 \
                      libgdk-pixbuf2.0-0 \
                      libglib2.0-0 \
                      libgtk-3-0 \
                      libnspr4 \
                      libpango-1.0-0 \
                      libpangocairo-1.0-0 \
                      libstdc++6 \
                      libx11-6 \
                      libx11-xcb1 \
                      libxcb1 \
                      libxcomposite1 \
                      libxcursor1 \
                      libxdamage1 \
                      libxext6 \
                      libxfixes3 \
                      libxi6 \
                      libxrandr2 \
                      libxrender1 \
                      libxss1 \
                      libxtst6 \
                      ca-certificates \
                      fonts-liberation \
                      libappindicator1 \
                      libnss3 \
                      lsb-release \
                      xdg-utils
EOF

  sleep 2
}

# Mulai eksekusi skrip dengan panggilan fungsi yang diperlukan

# Panggil fungsi untuk membuat pengguna
system_create_user

# Panggil fungsi untuk mengunduh kode dari repositori menggunakan git
system_git_clone

# Panggil fungsi untuk memperbarui sistem
system_update

# Panggil fungsi untuk menginstal Node.js
system_node_install

# Panggil fungsi untuk menginstal Docker
system_docker_install

# Panggil fungsi untuk menginstal dependensi Puppeteer
system_puppeteer_dependencies

# ... Panggil fungsi lainnya sesuai kebutuhan

# Jangan lupa panggil fungsi lainnya untuk konfigurasi dan setup lainnya sesuai kebutuhan

# Setelah semua konfigurasi dan instalasi selesai, Anda bisa menambahkan perintah terakhir atau tindakan tambahan
# Sebagai contoh, untuk mengatur ulang server atau merestart aplikasi

# Selesai
echo "Pengaturan sistem telah selesai."
