#!/bin/bash
# 
# fungsi untuk setup backend aplikasi

#######################################
# membuat mysql db menggunakan docker
# Argumen:
#   Tidak ada
#######################################
backend_mysql_buat() {
  print_banner
  printf "${WHITE} 💻 Membuat database...${GRAY_LIGHT}"
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

#######################################
# mengatur variable environment untuk backend.
# Argumen:
#   Tidak ada
#######################################
backend_setel_env() {
  print_banner
  printf "${WHITE} 💻 Mengatur variabel lingkungan (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # pastikan idempotensi
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # pastikan idempotensi
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/whaticket/backend/.env
NODE_ENV=
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
PROXY_PORT=443
PORT=8080

DB_HOST=localhost
DB_DIALECT=
DB_USER=${db_user}
DB_PASS=${db_pass}
DB_NAME=${db_name}

JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}
[-]EOF
EOF

  sleep 2
}

#######################################
# menginstal dependensi node.js
# Argumen:
#   Tidak ada
#######################################
backend_node_kebutuhan() {
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
# mengompilasi kode backend
# Argumen:
#   Tidak ada
#######################################
backend_node_bangun() {
  print_banner
  printf "${WHITE} 💻 Membangun kode backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npm install
  npm run build
EOF

  sleep 2
}

#######################################
# memperbarui kode frontend
# Argumen:
#   Tidak ada
#######################################
backend_perbarui() {
  print_banner
  printf "${WHITE} 💻 Memperbarui backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket
  git pull
  cd /home/deploy/whaticket/backend
  npm install
  rm -rf dist 
  npm run build
  npx sequelize db:migrate
  npx sequelize db:seed
  pm2 restart all
EOF

  sleep 2
}

#######################################
# menjalankan db migrate
# Argumen:
#   Tidak ada
#######################################
backend_db_migrate() {
  print_banner
  printf "${WHITE} 💻 Menjalankan db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# menjalankan db seed
# Argumen:
#   Tidak ada
#######################################
backend_db_seed() {
  print_banner
  printf "${WHITE} 💻 Menjalankan db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/whaticket/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# memulai backend menggunakan pm2 dalam 
# mode produksi.
# Argumen:
#   Tidak ada
#######################################
backend_mulai_pm2() {
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

#######################################
# mengatur nginx untuk backend
# Argumen:
#   Tidak ada
#######################################
backend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Mengatur nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/whaticket-backend << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:8080;
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

ln -s /etc/nginx/sites-available/whaticket-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}
