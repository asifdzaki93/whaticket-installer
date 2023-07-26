#!/bin/bash
# 
# Functions for setting up app backend

# Fungsi print_banner dan lainnya di sini ...

#######################################
# Fungsi: backend_mysql_create
# Argumen: None
#######################################
backend_mysql_create() {
  print_banner
  printf "${WHITE} 💻 Membuat database MySQL menggunakan Docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run --name whaticketdb \
                -e MYSQL_ROOT_PASSWORD=${mysql_root_password} \
                -e MYSQL_DATABASE=${db_name} \
                -e MYSQL_USER=${db_user} \
                -e MYSQL_PASSWORD=${db_pass} \
             --restart always \
                -p 3306:3306 \
                -d mariadb:latest \
             --character-set-server=utf8mb4 \
             --collation-server=utf8mb4_bin
EOF

  sleep 2
}

# Fungsi backend_set_env di sini ...

#######################################
# Fungsi: backend_node_dependencies
# Argumen: None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Menginstal dependensi backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npm install
EOF

  sleep 2
}

#######################################
# Fungsi: backend_node_build
# Argumen: None
#######################################
backend_node_build() {
  print_banner
  printf "${WHITE} 💻 Mengekompilasi kode backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npm install
  npm run build
EOF

  sleep 2
}

# Fungsi backend_update di sini ...

# Fungsi backend_db_migrate di sini ...

# Fungsi backend_db_seed di sini ...

#######################################
# Fungsi: backend_start_pm2
# Argumen: None
#######################################
backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Memulai pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  pm2 start dist/server.js --name whaticket-backend
EOF

  sleep 2
}

# Fungsi backend_nginx_setup di sini ...

# Implementasi fungsi lainnya di sini ...

# Mulai eksekusi skrip dengan panggilan fungsi yang diperlukan

# Panggil fungsi untuk membuat database MySQL menggunakan Docker
backend_mysql_create

# Panggil fungsi untuk mengatur variabel lingkungan backend
backend_set_env

# Panggil fungsi untuk menginstal dependensi backend
backend_node_dependencies

# Panggil fungsi untuk mengkompilasi kode backend
backend_node_build

# Panggil fungsi untuk memperbarui backend
backend_update

# Panggil fungsi untuk menjalankan db:migrate pada backend (jika diperlukan)
backend_db_migrate

# Panggil fungsi untuk menjalankan db:seed pada backend (jika diperlukan)
backend_db_seed

# Panggil fungsi untuk memulai pm2 untuk backend
backend_start_pm2

# Panggil fungsi untuk mengatur nginx untuk backend (jika diperlukan)
backend_nginx_setup

# Setelah semua konfigurasi dan instalasi selesai, Anda bisa menambahkan perintah terakhir atau tindakan tambahan
# Sebagai contoh, untuk mengatur ulang server atau merestart aplikasi

# Selesai
echo "Pengaturan backend telah selesai."
