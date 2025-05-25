#!/bin/bash

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Détection de la distribution...${NC}"

# Détection de la distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo -e "${RED}Impossible de détecter la distribution.${NC}"
    exit 1
fi

echo -e "→ Distribution détectée : ${GREEN}$DISTRO${NC}"

# Fonctions pour chaque système
install_ubuntu_debian() {
    echo -e "${CYAN}Mise à jour APT...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl gnupg software-properties-common python3-pip

    echo -e "${CYAN}Installation des paquets de base...${NC}"
    sudo apt install -y nmap whois john hashcat gobuster pdfcrack hydra

    echo -e "${CYAN}Installation de CrackMapExec via pipx...${NC}"
    pip install pipx
    pipx install crackmapexec

    echo -e "${CYAN}Installation de Medusa (compilation)...${NC}"
    sudo apt install -y libpq-dev libsvn-dev libncurses5-dev
    git clone https://github.com/jmk-foofus/medusa.git
    cd medusa && ./configure && make && sudo make install
    cd .. && rm -rf medusa

    echo -e "${CYAN}Installation de Metasploit...${NC}"
    curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall > msfinstall
    chmod +x msfinstall && sudo ./msfinstall && rm msfinstall
}

install_kali() {
    echo -e "${CYAN}Installation avec les paquets Kali...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y kali-linux-top10 kali-tools-passwords \
        crackmapexec medusa metasploit-framework gobuster \
        john hashcat hydra whois nmap pdfcrack
}

install_arch() {
    echo -e "${CYAN}Installation avec Pacman...${NC}"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm nmap whois john hashcat gobuster hydra pdfcrack metasploit python-pip

    echo -e "${CYAN}Installation de CrackMapExec via pipx...${NC}"
    pip install pipx
    pipx ensurepath
    pipx install crackmapexec

    echo -e "${CYAN}Installation de Medusa (AUR ou compilation)...${NC}"
    echo -e "${RED}Medusa n'est pas dans les dépôts Arch. Installe-le via AUR ou compilation manuelle.${NC}"
}

install_endeavouros() {
    echo -e "${CYAN}Installation avec Pacman...${NC}"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm nmap whois john hashcat gobuster hydra pdfcrack metasploit python-pip

    echo -e "${CYAN}Installation de CrackMapExec via pipx...${NC}"
    pip install pipx
    pipx ensurepath
    pipx install crackmapexec

    echo -e "${CYAN}Installation de Medusa (AUR ou compilation)...${NC}"
    echo -e "${RED}Medusa n'est pas dans les dépôts Arch. Installe-le via AUR ou compilation manuelle.${NC}"
}

# Rediriger vers l'installation appropriée
case "$DISTRO" in
    ubuntu|debian)
        install_ubuntu_debian
        ;;
    kali)
        install_kali
        ;;
    arch|manjaro)
        install_arch
        ;;
    endeavouros)
        install_endeavouros
        ;;
    *)
        echo -e "${RED}Distribution non prise en charge automatiquement. Installe les outils manuellement.${NC}"
        ;;
esac

echo -e "${GREEN}✅ Installation terminée !${NC}"
