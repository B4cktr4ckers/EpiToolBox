#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

function show_banner() {
cat << "EOF"

___ ___________      ._____________           .__ __________                   ___
/ /  \_   _____/_____ |__\__    ___/___   ____ |  |\______   \ _______  ___      \ \
\ \   |    __)_\____ \|  | |    | /  _ \ /  _ \|  | |    |  _//  _ \  \/  /      / /
< <   |        \  |_> >  | |    |(  <_> |  <_> )  |_|    |   (  <_> >    <       > >
/ /  /_______  /   __/|__| |____| \____/ \____/|____/______  /\____/__/\_ \ /\   \ \
\_\_         \/|__|                                        \/            \/ \/  _/_/
             CyberSec Toolbox 🧰
EOF
echo -e "${CYAN}Bienvenue dans ta boîte à outils cybersécurité${NC}"
}

# Menu principal
function main_menu() {
    clear
    show_banner
    echo -e "${GREEN}[1] Reconnaissance"
    echo -e "[2] Bruteforce"
    echo -e "[3] Analyse PDF"
    echo -e "[4] OSINT"
    echo -e "[5] Exploitation"
    echo -e "[6] Quitter${NC}"
    echo ""
    read -p ">> Choix : " choice

    case $choice in
        1) recon_menu ;;
        2) brute_menu ;;
        3) pdf_menu ;;
        4) osint_menu ;;
        5) exploit_menu ;;
        6) exit 0 ;;
        *) echo -e "${RED}Choix invalide.${NC}" ; sleep 2 ; main_menu ;;
    esac
}

# Sous-menus

function recon_menu() {
    clear
    echo -e "${CYAN}[ Reconnaissance ]${NC}"
    echo "1. Nmap"
    echo "2. Whois"
    echo "3. DNSenum (à ajouter si voulu)"
    echo "0. Retour"
    read -p ">> " opt
    case $opt in
        1) read -p "Cible : " tgt; nmap -A "$tgt" ;;
        2) read -p "Domaine : " dom; whois "$dom" ;;
        0) main_menu ;;
        *) echo "Invalide"; sleep 1; recon_menu ;;
    esac
    pause
}

function brute_menu() {
    clear
    echo -e "${CYAN}[ Bruteforce ]${NC}"
    echo "1. Hydra (FTP)"
    echo "2. Medusa (FTP)"
    echo "0. Retour"
    read -p ">> " opt
    case $opt in
        1) read -p "IP : " ip; read -p "User : " user; hydra -l "$user" -P /usr/share/wordlists/rockyou.txt ftp://"$ip" ;;
        2) read -p "IP : " ip; read -p "User : " user; medusa -u "$user" -P /usr/share/wordlists/rockyou.txt -h "$ip" -M ftp ;;
        0) main_menu ;;
        *) echo "Invalide"; sleep 1; brute_menu ;;
    esac
    pause
}

function pdf_menu() {
    clear
    echo -e "${CYAN}[ Analyse PDF ]${NC}"
    echo "1. Extraire info avec pdftk"
    echo "0. Retour"
    read -p ">> " opt
    case $opt in
        1) read -p "Fichier PDF : " file; pdftk "$file" dump_data ;;
        0) main_menu ;;
        *) echo "Invalide"; sleep 1; pdf_menu ;;
    esac
    pause
}

function osint_menu() {
    clear
    echo -e "${CYAN}[ OSINT ]${NC}"
    echo "1. theHarvester"
    echo "0. Retour"
    read -p ">> " opt
    case $opt in
        1) read -p "Domaine/email : " tgt; theHarvester -d "$tgt" -b google ;;
        0) main_menu ;;
        *) echo "Invalide"; sleep 1; osint_menu ;;
    esac
    pause
}

function exploit_menu() {
    clear
    echo -e "${CYAN}[ Exploitation ]${NC}"
    echo "1. Lancer Metasploit"
    echo "0. Retour"
    read -p ">> " opt
    case $opt in
        1) msfconsole ;;
        0) main_menu ;;
        *) echo "Invalide"; sleep 1; exploit_menu ;;
    esac
    pause
}

function pause() {
    read -p "Appuie sur Entrée pour revenir au menu..."
    main_menu
}

main_menu
