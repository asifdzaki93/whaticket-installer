#!/bin/bash
# 
# pengelolaan sistem

#######################################
# membuat pengguna
# Argumen:
#   Tidak ada
#######################################
system_create_user() {
  print_banner
  printf "${WHITE} 💻 Sekarang, kita akan membuat pengguna untuk penyebaran...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  useradd -m -p $(openssl passwd -crypt $deploy_password) -s /bin/bash -G sudo deploy
  usermod -aG sudo deploy
EOF

  sleep 2
}

#######################################
# mengkloning repositori menggunakan git
# Argumen:
#   Tidak ada
#######################################
system_git_clone() {
  print_banner
  printf "${WHITE} 💻 Mendownload kode whaticket...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  git clone https://github.com/canove/whaticket /home/deploy/whaticket/
EOF

  sleep 2
}

#######################################
# memperbarui sistem
# Argumen:
#   Tidak ada
#######################################
system_update() {
  print_banner
  printf "${WHITE} 💻 Mari kita perbarui sistem...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
EOF

  sleep 2
}

#######################################
# menginstal node
# Argumen:
#   Tidak ada
#######################################
system_node_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal nodejs...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
  apt-get install -y nodejs
EOF

  sleep 2
}

#######################################
# menginstal docker
# Argumen:
#   Tidak ada
#######################################
system_docker_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal docker...${GRAY_LIGHT}"
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

#######################################
# Menanyakan lokasi file yang berisi
# banyak URL untuk streaming.
# Global:
#   WHITE
#   GRAY_LIGHT
#   BATCH_DIR
#   PROJECT_ROOT
# Argumen:
#   Tidak ada
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

#######################################
# menginstal pm2
# Argumen:
#   Tidak ada
#######################################
system_pm2_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal pm2...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  npm install -g pm2
  pm2 startup ubuntu -u deploy
  env PATH=\$PATH:/usr/bin pm2 startup ubuntu -u deploy --hp /home/deploy
EOF

  sleep 2
}

#######################################
# menginstal snapd
# Argumen:
#   Tidak ada
#######################################
system_snapd_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal snapd...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y snapd
  snap install core
  snap refresh core
EOF

  sleep 2
}

#######################################
# menginstal certbot
# Argumen:
#   Tidak ada
#######################################
system_certbot_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal certbot...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt-get remove certbot
  snap install --classic certbot
  ln -s /snap/bin/certbot /usr/bin/certbot
EOF

  sleep 2
}

#######################################
# menginstal nginx
# Argumen:
#   Tidak ada
#######################################
system_nginx_install() {
  print_banner
  printf "${WHITE} 💻 Menginstal nginx...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y nginx
  rm /etc/nginx/sites-enabled/default
EOF

  sleep 2
}

#######################################
# merestart nginx
# Argumen:
#   Tidak ada
#######################################
system_nginx_restart() {
  print_banner
  printf "${WHITE} 💻 Mengulang kembali nginx...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  service nginx restart
EOF

  sleep 2
}

#######################################
# setup untuk nginx.conf
# Argumen:
#   Tidak ada
#######################################
system_nginx_conf() {
  print_banner
  printf "${WHITE} 💻 Mengkonfigurasi nginx...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - root << EOF

cat > /etc/nginx/conf.d/whaticket.conf << 'END'
client_max_body_size 20M;
END

EOF

  sleep 2
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_certbot_setup() {
  print_banner
  printf "${WHITE} 💻 Pengaturan certbot...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_domain=$(echo "${backend_url/https:\/\/}")
  frontend_domain=$(echo "${frontend_url/https:\/\/}")

  sudo su - root <<EOF
  certbot -m $deploy_email \
          --nginx \
          --agree-tos \
          --non-interactive \
          --domains $backend_domain,$frontend_domain
EOF

  sleep 2
}
