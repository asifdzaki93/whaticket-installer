#!/bin/bash
# 
# Functions for setting up app frontend

# Fungsi print_banner dan lainnya di sini ...

#######################################
# Fungsi: frontend_node_dependencies
# Argumen: None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Menginstal dependensi frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/frontend
  npm install
EOF

  sleep 2
}

#######################################
# Fungsi: frontend_node_build
# Argumen: None
#######################################
frontend_node_build() {
  print_banner
  printf "${WHITE} 💻 Mengekompilasi kode frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/frontend
  npm install
  npm run build
EOF

  sleep 2
}

#######################################
# Fungsi: frontend_update
# Argumen: None
#######################################
frontend_update() {
  print_banner
  printf "${WHITE} 💻 Memperbarui frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket
  git pull
  cd /home/deploy/whaticket/frontend
  npm install
  rm -rf build
  npm run build
  pm2 restart all
EOF

  sleep 2
}

#######################################
# Fungsi: frontend_set_env
# Argumen: None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Mengatur variabel lingkungan frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # Memastikan idempotensi
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/whaticket/frontend/.env
REACT_APP_BACKEND_URL=${backend_url}
[-]EOF
EOF

  sleep 2
}

#######################################
# Fungsi: frontend_start_pm2
# Argumen: None
#######################################
frontend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Memulai pm2 (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/frontend
  pm2 start server.js --name whaticket-frontend
  pm2 save
EOF

  sleep 2
}

#######################################
# Fungsi: frontend_nginx_setup
# Argumen: None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Pengaturan nginx untuk frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/whaticket-frontend << 'END'
server {
  server_name $frontend_hostname;

  location / {
    proxy_pass http://127.0.0.1:3333;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}
END

ln -s /etc/nginx/sites-available/whaticket-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}

# Implementasi fungsi lainnya di sini ...

# Mulai eksekusi skrip dengan panggilan fungsi yang diperlukan

# Panggil fungsi untuk menginstal dependensi frontend
frontend_node_dependencies

# Panggil fungsi untuk mengkompilasi kode frontend
frontend_node_build

# Panggil fungsi untuk memperbarui frontend
frontend_update

# Panggil fungsi untuk mengatur variabel lingkungan frontend
frontend_set_env

# Panggil fungsi untuk memulai pm2 untuk frontend
frontend_start_pm2

# Panggil fungsi untuk mengatur nginx untuk frontend
frontend_nginx_setup

# Setelah semua konfigurasi dan instalasi selesai, Anda bisa menambahkan perintah terakhir atau tindakan tambahan
# Sebagai contoh, untuk mengatur ulang server atau merestart aplikasi

# Selesai
echo "Pengaturan frontend telah selesai."
