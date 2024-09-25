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

nmap_option() {
        clear
		echo
        echo "=================================================="
        echo "                  MENU NMAP"
        echo "=================================================="
		echo
        echo -e "\e[1;32m  1. Barrido de Ping (-sn)\e[0m"
        echo -e " \e[1;39mNota: Identificar hosts activos en la red. 
                    No hace análisis de puertos posterior\e[0m"
        echo
        echo -e "\e[1;32m  2. No Ping (-Pn)\e[0m"
        echo -e " \e[1;39mNota: Pasa directo al escaneo de puertos\e[0m"
        echo
        echo -e "\e[1;32m  3. Solo lista equipos (-sL)\e[0m"
        echo -e "\e[1;39mNota: Lista equipos y hace resolucion inversa DNS\e[0m"
        echo
        echo -e "\e[1;32m  4. Ping ICMP (-PP)\e[0m"
        echo -e " \e[1;39mNota: Identificar hosts activos en la red mediante 
                    un ICMP Timestamp Request\e[0m"
        echo
        echo -e "\e[1;32m  2. Escanear puerto y deteccion de version y 
                sistema operativo (-O -sV -p)\e[0m"
        echo -e " \e[1;39mNota: Escaneo de un simple puerto o un rango de 
                ellos, ademas, detecta la version de los puertos e 
                identifica el sistema operativo.\e[0m"
        echo
        echo "1.  Deteccion Sistema Operativo (-O)"
        echo "1.  Evadir Firewall / IDS (-f)"
        
        echo "6.  Escaneo Full (-O | -sV | -sC | -A | -p | -script all)"
        echo "1.  Escaneo de Red"
        echo "1.  Escaneo de Red"
		echo
        echo "0.  Volver al Menú Principal"
		echo
        echo "========================"
		echo
        read -p "Ingrese una opción (0-1): " opcionnmap

}

# Función para escanear la red - Opcion 1
escaneo_de_red() {
	echo
    # Pedir la red o IP a escanear
    read -p "Ingrese la red o IP a escanear (ejemplo: 192.168.1.0/24): " network
    if [ -z "$network" ]; then
		echo
        echo "Error: no se ha proporcionado una red o IP válida."
		echo
        read -p "Presione [Enter] para continuar..."
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
