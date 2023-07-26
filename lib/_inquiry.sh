#!/bin/bash

get_frontend_url() {
  
  print_banner
  printf "${WHITE} 💻 Masukkan domain dari antarmuka web:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_url
}

get_backend_url() {
  
  print_banner
  printf "${WHITE} 💻 Masukkan domain dari API Anda:${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_url
}

get_urls() {
  
  get_frontend_url
  get_backend_url
}

software_update() {
  
  frontend_update
  backend_update
}

inquiry_options() {
  
  print_banner
  printf "${WHITE} 💻 Apa yang Anda butuhkan untuk dilakukan?${GRAY_LIGHT}"
  printf "\n\n"
  printf "   [1] Pasang\n"
  printf "   [2] Perbarui\n"
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
