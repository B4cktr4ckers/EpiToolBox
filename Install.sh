#!/bin/bash

GREEN='\033[0;32m' ## Couleur verte pour les messages de succès
RED='\033[0;31m' ## On a le rouge pour si il y a une erreur
NC='\033[0m' ## Pas de couleur

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Ce script doit être exécuté en tant que root (sudo).${NC}"
    exit 1
fi

echo -e "${GREEN}Mise à jour du système...${NC}"
apt update && apt upgrade -y

APT_PACKAGES=(
    nmap
    hydra
    medusa
    whois
    john
    hashcat
    crackmapexec
    pdfcrack
    gobuster
)
echo -e "${GREEN}Installation des paquets via apt...${NC}"
for pkg in "${APT_PACKAGES[@]}"; do
    echo -e "${GREEN}Installation de $pkg...${NC}"
    apt install -y "$pkg"
done
echo -e "${GREEN}Installation de Metasploit...${NC}"
curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall > msfinstall
chmod +x msfinstall
./msfinstall
rm msfinstall
echo -e "${RED}Maltego ne peut pas être installé automatiquement via apt.${NC}"
echo -e "${RED}Va sur https://www.maltego.com/download/ pour télécharger le .deb${NC}"
echo -e "${GREEN}Tous les outils disponibles ont été installés.${NC}"
