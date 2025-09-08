#!/bin/bash

MERAH="\e[31m"
HIJAU="\e[32m"
KUNING="\e[33m"
RESET="\e[0m"

ID=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
nebula="https://github.com/alands-offc/Pterodactyl-nebula/raw/refs/heads/main/Thema/nebula.zip"
elysium="https://github.com/alands-offc/alxzydb/raw/main/ElysiumTheme.zip"
check_distro() {
    if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
        echo -e "${HIJAU}Memuat konfigurasi untuk ${ID}...${RESET}"
    else
        echo -e "${MERAH}Installer gagal!${RESET}"
        echo -e "Hanya support untuk Ubuntu/Debian."
        exit 1
    fi
}

install_nodejs() {
    echo -e "${HIJAU}Menginstall Node.js...${RESET}"
    sleep 1

    if [ "$1" = "blueprint" ]; then
        echo -e "${HIJAU}Menggunakan Node.js 20.x untuk Blueprint.${RESET}"
        NODE_VERSION="20"
    else
        echo -e "${HIJAU}Menggunakan Node.js 16.x untuk Elysium.${RESET}"
        NODE_VERSION="16"
    fi

    OS_VERSION=$(lsb_release -rs | cut -d. -f1)
    OS_ID=$(lsb_release -is | tr '[:upper:]' '[:lower:]')

    sudo apt-get install -y ca-certificates curl gnupg

    if [ "$OS_ID" = "ubuntu" ] && [ "$OS_VERSION" -le 22 ]; then
        echo -e "${KUNING}Detected $OS_ID $OS_VERSION → menggunakan keyring + nodistro main.${RESET}"
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
            | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION}.x nodistro main" \
            | sudo tee /etc/apt/sources.list.d/nodesource.list
    else
        echo -e "${KUNING}Detected $OS_ID $OS_VERSION → menggunakan setup script NodeSource.${RESET}"
        curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | sudo -E bash -
    fi

    sudo apt-get update
    sudo apt-get install -y nodejs
}

install_blueprint() {
    echo -e "${HIJAU}Menginstall Blueprint...${RESET}"
    install_nodejs "blueprint"
    sleep 2
    npm i -g yarn
    sleep 1
    cd /var/www/pterodactyl || { echo -e "${MERAH}Direktori Pterodactyl tidak ditemukan.${RESET}"; exit 1; }
    yarn
    sudo apt install -y zip unzip git curl wget
    wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
    unzip -o release.zip
    touch .blueprintrc
    echo 'WEBUSER="www-data";
OWNERSHIP="www-data:www-data";
USERSHELL="/bin/bash";' | sudo tee .blueprintrc >/dev/null
    chmod +x blueprint.sh
    bash blueprint.sh
    sleep 3
    echo -e "${HIJAU}Instalasi Blueprint selesai!${RESET}"
    cd
}

install_nebula() {
    echo -e "${KUNING}Menginstall tema Nebula...${RESET}"
    install_blueprint
    cd /var/www || { echo -e "${MERAH}Direktori /var/www tidak ditemukan.${RESET}"; exit 1; }
    wget "$nebula"
    unzip -o nebula.zip
    cd pterodactyl || { echo -e "${MERAH}Direktori Pterodactyl tidak ditemukan.${RESET}"; exit 1; }
    blueprint -install nebula
    echo -e "${HIJAU}Tema Nebula berhasil diinstal!${RESET}"
    exit 0
}

install_elysium() {
    echo -e "${KUNING}Menginstall tema Elysium...${RESET}"
    install_nodejs
    cd /var/www || { echo -e "${MERAH}Direktori /var/www tidak ditemukan.${RESET}"; exit 1; }
    wget "$elysium"
    unzip -o ElysiumTheme.zip
    npm i -g yarn
    cd pterodactyl || { echo -e "${MERAH}Direktori Pterodactyl tidak ditemukan.${RESET}"; exit 1; }
    php artisan migrate
    yarn
    export NODE_OPTIONS=--openssl-legacy-provider
    yarn build:production
    php artisan optimize:clear
    echo -e "${HIJAU}Tema Elysium berhasil diinstal!${RESET}"
    exit 0
}
install_nooktheme() {
  install_nodejs
  echo -e "${KUNING}installing nook theme ${RESET}"
  cd /var/www/pterodactyl
  php artisan down
  curl -L https://github.com/alands-offc/NookTheme/releases/latest/download/panel.tar.gz | tar -xzv
  chmod -R 755 storage/* bootstrap/cache
  composer install --no-dev --optimize-autoloader
  yarn
  export NODE_OPTIONS=--openssl-legacy-provider
  yarn build:production 
  php artisan view:clear
  php artisan config:clear
  php artisan migrate --seed --force
  chown -R www-data:www-data /var/www/pterodactyl/*
  php artisan queue:restart
  php artisan up
  echo -e "${HIJAU} Instalasi nook theme remake by alxzy selesai ${RESET}"
}
clear
check_distro
sudo apt update -y && sudo apt upgrade -y
clear
echo -e "${HIJAU}Selamat datang di Pterodactyl Theme Installer${RESET}"
sleep 1
echo -e "${HIJAU}Silakan memilih tema yang tersedia di bawah ini${RESET}"
sleep 1
PS3="Pilih tema (1-4): "

select theme in "NebulaTheme" "ElysiumTheme" "NookTheme (Remake)" "Keluar"; do
    case $theme in
        "NebulaTheme")
            install_nebula
            break
            ;;
        "ElysiumTheme")
            install_elysium
            break
            ;;
        "NookTheme (Remake)")
            install_nooktheme
          break
           ;;
        "Keluar")
            echo -e "${KUNING}Terima kasih. Keluar dari installer.${RESET}"
            exit 0
            ;;
        *)
            echo -e "${MERAH}Pilihan tidak valid. Silakan coba lagi.${RESET}"
            ;;
    esac
done
