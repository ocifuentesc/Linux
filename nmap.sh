#!/bin/bash
##
##
## ░█████╗░░█████╗░██╗███████╗██╗░░░██╗███████╗███╗░░██╗████████╗███████╗░██████╗░█████╗░
## ██╔══██╗██╔══██╗██║██╔════╝██║░░░██║██╔════╝████╗░██║╚══██╔══╝██╔════╝██╔════╝██╔══██╗
## ██║░░██║██║░░╚═╝██║█████╗░░██║░░░██║█████╗░░██╔██╗██║░░░██║░░░█████╗░░╚█████╗░██║░░╚═╝
## ██║░░██║██║░░██╗██║██╔══╝░░██║░░░██║██╔══╝░░██║╚████║░░░██║░░░██╔══╝░░░╚═══██╗██║░░██╗
## ╚█████╔╝╚█████╔╝██║██║░░░░░╚██████╔╝███████╗██║░╚███║░░░██║░░░███████╗██████╔╝╚█████╔╝
## ░╚════╝░░╚════╝░╚═╝╚═╝░░░░░░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚══════╝╚═════╝░░╚════╝░
##
##
## @author	Oscar Cifuentes Cisterna
## @copyright	Copyright © 2024 Oscar Cifuentes Cisterna
## @license	https://wwww.gnu.org/licenses/gpl.txt
## @email	oscar@ocifuentesc.cl
## @web		https://oscarcifuentes.cl
## @github	https://github.com/ocifuentesc
##
##

###################################
## Sistemas Operativos Testeados ##
###################################
#
# - MacOS 15.0 M1 
# - Kali Linux 2024 ARM64
# - Debian 12 ARM64

# Colores
VERDE="\033[1;32m"
NEGRITA="\033[1;39m"
RESET="\033[0m"

nmap_option() {
        clear
		echo
        echo -e "${VERDE}${NEGRITA}=============================================================="
        echo -e "|                           MENU NMAP                        |"
        echo -e "==============================================================${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  1. Barrido de Ping (-sn)${RESET}"
        echo -e "${NEGRITA}     Nota: Identificar hosts activos en la red. No hace análisis de puertos posterior${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  2. No Ping (-Pn)${RESET}"
        echo -e "${NEGRITA}     Nota: Pasa directo al escaneo de puertos${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  3. Solo lista equipos (-sL)${RESET}"
        echo -e "${NEGRITA}     Nota: Lista equipos y con resolucion inversa DNS${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  4. Ping ICMP (-PP)${RESET}"
        echo -e "${NEGRITA}     Nota: Identificar hosts activos en la red mediante un ICMP Timestamp Request${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  5. Escanear puerto y deteccion de version y sistema operativo (-O -sV -p)${RESET}"
        echo -e "${NEGRITA}     Nota: Escaneo de un simple puerto o un rango de ellos."
        echo -e "     Detecta la version de los puertos e identifica el sistema operativo.${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  6. Escaneo TCP (-sT)(*)${RESET}"
        echo -e "${NEGRITA}     Nota: Determinar el estado de un puerto (abierto, cerrado o filtrado).${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  7. Escaneo SYN (-sS)(*)${RESET}"
        echo -e "${NEGRITA}     Nota: Escaneo sigiloso y mas rapido que el TCP${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  8. Escaneo UDP Rapido (-sU -F) (*)${RESET}"
        echo -e "${NEGRITA}     Nota: Se escanea los primeros 100 puertos.${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA}  9. Escaneo UDP (-sU) (*)${RESET}"
        echo -e "${NEGRITA}     Nota: Se escanea todo los puertos UDP. Puerde tardar varias horas${RESET}"
        echo
        echo -e "${VERDE}${NEGRITA} 10. Escaneo de vulnerabilidades (-sV --script=vulners)${RESET}"
        echo -e "${NEGRITA}     Nota: Utiliza la base de datos de vulnerabilidades junto con la deteccion"
        echo -e "     de versiones de software${RESET}"
		echo
        echo -e "${VERDE}${NEGRITA}  0.  Volver al Menú Principal${RESET}"
		echo
        echo -e "${VERDE}${NEGRITA}==================================================${RESET}"
		echo
        read -p $'\e[1;32mIngrese una opción (0-10): \e[0m' opcionnmap

}

# Función para escanear la red - Opcion 1
escaneo_de_red() {
    clear
	echo
    # Pedir la red o IP a escanear
    read -p "Ingrese la red o IP a escanear (ejemplo: 192.168.1.0/24): " network
    if [ -z "$network" ]; then
        echo "Error: no se ha proporcionado una red o IP válida."
        return
    fi

    echo
    echo "Escaneando la red $network..."
    echo
    nmap -sn "$network" | grep "Nmap scan report" | awk '{print $NF}'
    echo
    read -p "Presione [Enter] para continuar..."
    # Después de esto volverá al menú NMAP automáticamente gracias al ciclo
}


#if ! command -v nmap &> /dev/null; then
#    echo "nmap no está instalado. Por favor, instálalo primero."
#    exit 1
#fi


# Menú principal
while true; do
    nmap_option

    case $opcionnmap in
        1) escaneo_de_red ;;
        0) exit 0 ;;
        *)
            echo
			echo "Opción no válida."
			echo
            read -p "Presione [Enter] para continuar..."
            ;;
    esac
done
