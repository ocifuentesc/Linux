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
# - Debian 10 ARM64
# - Debian 11 ARM64
# - Debian 12 ARM64
# - Ubuntu Server 20.04 ARM64
# - Ubuntu Server 24.04 ARM64
# - CentOS 9 Stream ARM64
# - CentOS 10 Stream ARM64
# - Alma Linux 9.4 ARM
# - Fedora Server 39 ARM
# - Fedora Server 40 ARM
# - Fedora Workstation 38 ARM
# - Fedora Workstation 40 ARM
# - Rocky Linux 9.4 ARM
# - ArchLinux ARM

# Colores
VERDE="\033[1;32m"
ROJO="\033[1;31m"
NEGRITA="\033[1;39m"
SUBRAYADO="\033[4m"
RESET="\033[0m"

# Función para mostrar el menú
show_menu() {
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|           MENU PRINCIPAL           |"
    echo -e "======================================"
	echo -e
    echo -e " 1.  PING a una IP o Dominio"
    echo -e " 2.  NSLOOKUP a una IP o Dominio"
    echo -e " 3.  Información del equipo"
    echo -e " 4.  Listar procesos activos"
    echo -e " 5.  Ver Usuarios del Sistema"
    echo -e " 6.  Ver cache ARP"
    echo -e " 7.  Mostrar las conexiones activas"
    echo -e " 8.  Actualizar Sistema"
    echo -e " 9.  Borrar caché DNS y Temporales"
	echo -e "10.  Revisar Certificado SSL"
	echo -e
    echo -e " 0.  Salir"
	echo -e
    echo -e "======================================${RESET}"
	echo
    read -p $'\e[1;32mIngrese una opción (0-11): \e[0m' opcion
}

# Función para manejar la opción 1
ping_option() {
    clear
    echo
    read -p $'\e[1;32mIngrese dirección IP o Dominio: \e[0m' ping_target
    echo

    # Función para mostrar la barra de progreso
    show_progress() {
        local pid=$1
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while kill -0 "$pid" 2>/dev/null; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
        echo
    }

    # Realiza el ping en segundo plano
    ping -c 3 "$ping_target" > /dev/null 2>&1 &
    
    # Guarda el PID del comando ping
    pid=$!
    
    # Muestra la barra de progreso
    show_progress "$pid"

    # Espera a que termine el ping
    wait "$pid"

    # Verifica el estado de salida del comando ping
    if wait "$pid"; then
		clear
		echo
        echo -e "${VERDE}Respuesta recibida desde ${SUBRAYADO}$ping_target${RESET}"
		echo
    else
		clear
		echo
        echo -e "${ROJO}No se recibió respuesta desde ${SUBRAYADO}$ping_target${RESET}"
		echo
    fi

    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 2
nslookup_option() {
    clear
    echo
    read -p $'\e[1;32mIngrese dirección IP o Dominio: \e[0m' nslookup_target
    echo
    nslookup "$nslookup_target"
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 3
info_option() {
    # Detectamos el sistema operativo
    unamestr="${OSTYPE//[0-9.]/}"
    os=$(compgen -G "/etc/*release" > /dev/null && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "$unamestr")

    # Función para mostrar la barra de progreso giratoria
    show_progress() {
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while true; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
    }

    # Ejecución
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|    DETECTANTO SISTEMA OPERATIVO    |"
    echo -e "======================================${RESET}"
    echo

    # Inicia la barra de progreso giratoria en segundo plano
    show_progress &
    spinner_pid=$! # Guarda el PID del spinner
	echo
    # Simula un proceso de detección del sistema operativo
    sleep 2 # Simula un pequeño retraso antes de mostrar el resultado

    # Detiene el spinner
    kill "$spinner_pid" 2>/dev/null
	echo
    wait "$spinner_pid" 2>/dev/null # Asegúrate de que el proceso del spinner haya terminado
	echo
    echo -e "${VERDE}Sistema identificado como $os${RESET}"
	echo
    sleep 2
	clear

    case $os in
    #
    # Derivados de Debian y Red Hat
    #
    *Debian* | *Ubuntu* | *Kali* | *CentOS* | *Fedora* | *lmaLinux* | *Rocky* | *rch*)
        echo -e "${VERDE}=================================="
        echo -e "|     INFORMACION DEL EQUIPO     |"
        echo -e "==================================${RESET}"
        echo
        uname -a
        echo
        cat /etc/os-*
        echo
        echo -e "${VERDE}======================"
        echo -e "| INFORMACION DE RED |"
        echo -e "======================${RESET}"
        ip -c a
        echo
        echo -e "${VERDE}==========="
        echo -e "| MEMORIA |"
        echo -e "===========${RESET}"
        free -mth
        echo
        ;;

    #
    # MacOS
    #
    *darwin*)
        echo -e "${VERDE}=================================="
        echo -e "|     INFORMACION DEL EQUIPO     |"
        echo -e "==================================${RESET}"
        echo
        system_profiler SPHardwareDataType
        echo
        scutil --get HostName
        echo
        echo -e "${VERDE}======================"
        echo -e "| INFORMACION DE RED |"
        echo -e "======================${RESET}"
        echo
        scutil --nwi
        echo
        echo -e "${VERDE}==========="
        echo -e "| MEMORIA |"
        echo -e "===========${RESET}"
        sysctl hw.memsize
        echo
        top -l 1 | grep PhysMem
        echo
        ;;

    #
    # Otros
    #
    (*)
        echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
        echo
        ;;
    esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}


# Función para manejar la opción 4
processes_option() {
    clear
    echo
    echo -e "${VERDE}=============="
    echo -e "|  PROCESOS  |"
    echo -e "==============${RESET}"
    echo
    ps aux
    echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 5
users_option() {
    # Detectamos el sistema operativo
    unamestr="${OSTYPE//[0-9.]/}"
    os=$(compgen -G "/etc/*release" > /dev/null && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "$unamestr")

    # Función para mostrar la barra de progreso giratoria
    show_progress() {
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while true; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
    }

    # Ejecución
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|    DETECTANTO SISTEMA OPERATIVO    |"
    echo -e "======================================${RESET}"
    echo

    # Inicia la barra de progreso giratoria en segundo plano
    show_progress &
    spinner_pid=$! # Guarda el PID del spinner
	echo
    # Simula un proceso de detección del sistema operativo
    sleep 2 # Simula un pequeño retraso antes de mostrar el resultado

    # Detiene el spinner
    kill "$spinner_pid" 2>/dev/null
	echo
    wait "$spinner_pid" 2>/dev/null # Asegúrate de que el proceso del spinner haya terminado
	echo
    echo -e "${VERDE}Sistema identificado como $os${RESET}"
	echo
    sleep 2
	clear

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
	echo
	echo -e "${VERDE}============"
    echo -e "| USUARIOS |"
    echo -e "============${RESET}"
	echo
    awk -F: '{ print $1}' /etc/passwd
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
	echo
	echo -e "${VERDE}============"
    echo -e "| USUARIOS |"
    echo -e "============${RESET}"
	echo
    dscl . list /Users | grep -v '_'
	echo
	;;

	#
	# Otros
	#
	(*)
	echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
	echo
	;;

	esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 6
arp_cache_option() {
    # Detectamos el sistema operativo
    unamestr="${OSTYPE//[0-9.]/}"
    os=$(compgen -G "/etc/*release" > /dev/null && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "$unamestr")

    # Función para mostrar la barra de progreso giratoria
    show_progress() {
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while true; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
    }

    # Ejecución
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|    DETECTANTO SISTEMA OPERATIVO    |"
    echo -e "======================================${RESET}"
    echo

    # Inicia la barra de progreso giratoria en segundo plano
    show_progress &
    spinner_pid=$! # Guarda el PID del spinner
	echo
    # Simula un proceso de detección del sistema operativo
    sleep 2 # Simula un pequeño retraso antes de mostrar el resultado

    # Detiene el spinner
    kill "$spinner_pid" 2>/dev/null
	echo
    wait "$spinner_pid" 2>/dev/null # Asegúrate de que el proceso del spinner haya terminado
	echo
    echo -e "${VERDE}Sistema identificado como $os${RESET}"
	echo
    sleep 2
	clear

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
	echo
	echo -e "${VERDE}==============="
    echo -e "|  TABLA ARP  |"
    echo -e "===============${RESET}"
	echo
    arp
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
	echo
	echo -e "${VERDE}==============="
    echo -e "|  TABLA ARP  |"
    echo -e "===============${RESET}"
	echo
    arp -a
	echo
	;;

	#
	# Otros
	#
	(*)
	echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
	echo
	;;

	esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 7
connections_option() {
    # Detectamos el sistema operativo
    unamestr="${OSTYPE//[0-9.]/}"
    os=$(compgen -G "/etc/*release" > /dev/null && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "$unamestr")

    # Función para mostrar la barra de progreso giratoria
    show_progress() {
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while true; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
    }

    # Ejecución
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|    DETECTANTO SISTEMA OPERATIVO    |"
    echo -e "======================================${RESET}"
    echo

    # Inicia la barra de progreso giratoria en segundo plano
    show_progress &
    spinner_pid=$! # Guarda el PID del spinner
	echo
    # Simula un proceso de detección del sistema operativo
    sleep 2 # Simula un pequeño retraso antes de mostrar el resultado

    # Detiene el spinner
    kill "$spinner_pid" 2>/dev/null
	echo
    wait "$spinner_pid" 2>/dev/null # Asegúrate de que el proceso del spinner haya terminado
	echo
    echo -e "${VERDE}Sistema identificado como $os${RESET}"
	echo
    sleep 2
	clear

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
	echo
	echo -e "${VERDE}================"
    echo -e "|  CONEXIONES  |"
    echo -e "================${RESET}"
	echo
    netstat -tuln
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
	echo
	echo -e "${VERDE}================"
    echo -e "|  CONEXIONES  |"
    echo -e "================${RESET}"
	echo
    netstat -an
	echo
	;;

	#
	# Otros
	#
	(*)
	echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
	echo
	;;

	esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 8
update_option() {
   # Detectamos el sistema operativo
    unamestr="${OSTYPE//[0-9.]/}"
    os=$(compgen -G "/etc/*release" > /dev/null && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "$unamestr")

    # Función para mostrar la barra de progreso giratoria
    show_progress() {
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while true; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
    }

    # Ejecución
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|    DETECTANTO SISTEMA OPERATIVO    |"
    echo -e "======================================${RESET}"
    echo

    # Inicia la barra de progreso giratoria en segundo plano
    show_progress &
    spinner_pid=$! # Guarda el PID del spinner
	echo
    # Simula un proceso de detección del sistema operativo
    sleep 2 # Simula un pequeño retraso antes de mostrar el resultado

    # Detiene el spinner
    kill "$spinner_pid" 2>/dev/null
	echo
    wait "$spinner_pid" 2>/dev/null # Asegúrate de que el proceso del spinner haya terminado
	echo
    echo -e "${VERDE}Sistema identificado como $os${RESET}"
	echo
    sleep 2
	clear

    case $os in
    # Arch Linux
	*rch*)
    echo
	echo -e "${VERDE}Actualizando Sistema...${RESET}"
	echo
	sudo pacman -Syyu
	echo
	echo -e "${VERDE}Sistema Actualizado${RESET}"
	echo
	;;

	#
	# Derivados de Debian
	#
    *Debian* | *Ubuntu* | *Kali*)
    # Actualizamos la lista de paquetes disponibles y sus versiones en los repositorios
	echo
    echo -e "${VERDE}Descargando Lista de Repositorios...${RESET}"
	echo
	sudo apt-get update -y
	echo
	# Actualizamos paquetes del sistema
	echo -e "${VERDE}Actualizando Sistema...${RESET}"
	echo
	sudo apt upgrade -y && sudo apt dist-upgrade -y
	echo
	# Eliminamos del repositorio local, la caché, los paquetes de versiones antiguas e inútiles
	echo -e "${VERDE}Limpiando...${RESET}"
	echo
	sudo apt autoremove -y && sudo apt autoclean
	echo
	# Proceso terminado
	echo -e "${VERDE}Sistema Actualizado${RESET}"
	echo
	;;

    #
    # Derivados de Red Hat
    #
    *CentOS*| *Fedora* | *lmaLinux* | *Rocky*)
    # Actualizamos la lista de paquetes disponibles y sus versiones en los repositorios
    echo
	echo -e "${VERDE}Descargando Lista de Repositorios...${RESET}"
	echo
	sudo yum update -y
	echo
	# Actualizamos paquetes del sistema
	echo -e "${VERDE}Actualizando Sistema...${RESET}"
	echo
	sudo yum upgrade -y
	echo
	# Eliminamos del repositorio local, la caché, los paquetes de versiones antiguas e inútiles
	echo "${VERDE}Limpiando...${RESET}"
	echo
	sudo yum clean all
	echo
	# Proceso terminado
	echo "${VERDE}Sistema Actualizado${RESET}"
	echo
	;;

	#
	# MacOS
	#
	*darwin*)
	echo -e "${VERDE}Actualizando Sistema...${RESET}"
	echo
    softwareupdate --all --install --force
    echo
	;;

	#
	# Otros
	#
	(*)
	echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
	echo
	;;

	esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

# Función para manejar la opción 9
deldns_option() {
    # Detectamos el sistema operativo
   # Detectamos el sistema operativo
    unamestr="${OSTYPE//[0-9.]/}"
    os=$(compgen -G "/etc/*release" > /dev/null && cat /etc/*release | grep ^NAME | tr -d 'NAME="' || echo "$unamestr")

    # Función para mostrar la barra de progreso giratoria
    show_progress() {
        local delay=0.2
        local spinner=(' | ' ' / ' ' - ' ' \ ')

        while true; do
            for i in "${spinner[@]}"; do
                printf "\r%s" "$i"
                sleep "$delay"
            done
        done
    }

    # Ejecución
    clear
    echo
    echo -e "${VERDE}======================================"
    echo -e "|    DETECTANTO SISTEMA OPERATIVO    |"
    echo -e "======================================${RESET}"
    echo

    # Inicia la barra de progreso giratoria en segundo plano
    show_progress &
    spinner_pid=$! # Guarda el PID del spinner
	echo
    # Simula un proceso de detección del sistema operativo
    sleep 2 # Simula un pequeño retraso antes de mostrar el resultado

    # Detiene el spinner
    kill "$spinner_pid" 2>/dev/null
	echo
    wait "$spinner_pid" 2>/dev/null # Asegúrate de que el proceso del spinner haya terminado
	echo
    echo -e "${VERDE}Sistema identificado como $os${RESET}"
	echo
    sleep 2
	clear

    case $os in
	# Arch Linux
	*rch*)
	echo -e "${VERDE}Limpiando caches...${RESET}"
	echo
	sudo pacman -Qdt
	echo
	sudo pacman $(pacman -Qdtq)
	echo
	;;

	#
	# Derivados de Debian
	#
	*Debian* | *Ubuntu* | *Kali*)
    echo
    echo -e "${VERDE}Limpiando caché de APT...${RESET}"
    echo
    sudo apt-get clean
    echo
    sudo apt-get autoremove --purge
    echo
    echo -e "${VERDE}Limpiando caché de la memoria...${RESET}"
    echo
    sudo sync && sudo sysctl -w vm.drop_caches=3
    echo
    echo -e "${VERDE}Eliminar archivos de caché de usuario...${RESET}"
    echo
    sudo rm -rf ~/.cache/*
    echo
    ;;

    #
    # Derivados de Red Hat
    #
    *CentOS*| *Fedora* | *lmaLinux* | *Rocky*)
    echo
    echo -e "${VERDE}Limpiando caché de APT...${RESET}"
    echo
    sudo yum clean all
    echo
    sudo rm -rf /var/cache/yum
    echo
    echo -e "${VERDE}Limpiando caché de la memoria...${RESET}"
    echo
    sudo sync && sudo sysctl -w vm.drop_caches=3
    echo
    echo -e "${VERDE}Eliminando archivos caché de usuario...${RESET}"
    echo
    sudo rm -rf ~/.cache/*
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
    echo
    echo -e "${VERDE}Limpiando caché DNS...${RESET}"
    echo
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
    echo
    echo -e "${VERDE}Eliminando archivos caché del sistema...${RESET}"
	echo
    sudo rm -rf ~/Library/Caches/*
	echo
    sudo rm -rf /Library/Caches/*
    echo
    echo -e "${VERDE}Limpiando caché del sistema operativo...${RESET}"
	echo
    sudo purge
    echo
	;;

	#
	# Otros
	#
	(*)
	echo -e "${ROJO}Error: Arquitectura del Sistema Operativo NO soportada${RESET}"
	echo
	;;

	esac
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
}

## Función para manejar la opción 10 - Certificado SSL
certssl_option() {
	clear
	echo
	echo -e "${ROJO} ---> DEBES TENER INSTALADO openssl <---${RESET}"
	echo
	PROTOCOLS="https://|ldaps://|smtps://"

	TMPDIR="/tmp/uli-war-da.$$"

	cleanUp () {
	    rm -rf "${TMPDIR}"
	}

	trap cleanUp 0 1 2 3 4 5 6 7 8 9 10 12 13 14 15

	TMPDIR="$(mktemp -d)"

	# Solicitar IP o dominio si no se pasa como argumento
	if [ $# -eq 0 ]; then
	        echo -e "${VERDE}====================="
    echo -e "|    MODO DE USO    |"
    echo -e "====================="
		echo
    	echo -e "  example.com                      # Verificar un dominio en el puerto 443 (HTTPS)"
		echo -e "  https://example.com              # Verificar usando protocolo https en el puerto 443"
		echo -e "  https://example.com:8080         # Verificar usando protocolo https en el puerto 8080"
		echo
		echo -e "  sub.example.com                  # Verificar un subdominio en el puerto 443"
		echo -e "  https://sub.example.com          # Verificar un subdominio https en el puerto 443"
		echo -e "  https://sub.example.com:8080     # Verificar un subdominio https en el puerto 8080"
		echo 
    	echo -e "  192.168.1.1                      # Verificar una dirección IP en el puerto 443 (HTTPS)"
    	echo -e "  https://192.168.1.1              # Verificar una dirección IP en el puerto 443"
    	echo -e "  https://192.168.1.1:8080         # Verificar una dirección IP en el puerto 8080 (HTTPS)${RESET}"
		echo
        read -p $'\e[1;32mIntroduce la IP o dominio a verificar: \e[0m' HOST
		echo
	else
	    HOST="$1"
	fi

	PR="https://"
	PO=":443"
	URL="$(echo "${HOST}"|grep -oE "(${PROTOCOLS})?[^:/]*(:[0-9]*)?"|head -1)"
	HPR="$(echo "${URL}"|grep -oE "${PROTOCOLS}")"
	HPO="$(echo "${URL}"|grep -oE ":[0-9]+")"
	HO="${URL}"

	if [ -n "${HPR}" ]; then
	    HO="$(echo "${HO}"|sed -e "s,${HPR},,")"
	fi
	if [ -n "${HPO}" ]; then
	    HO="$(echo "${HO}"|sed -e "s,${HPO},,")"
	    PO="${HPO}"
	else
	    case "${HPR}" in
	      "https://")
	        PO=":443"
	        ;;
	      "ldaps://")
	        PO=":636"
	        ;;
	      "smtps://")
	        PO=":587"
	        ;;
	    esac
	fi

	openssl </dev/zero s_client 2>/dev/null -connect "${HO}${PO}" -servername "${HO}"\
	|openssl x509 -text >"${TMPDIR}/x509_text"

	< "${TMPDIR}/x509_text" grep -E "^\s*(Subject:|Issuer:|Not |DNS:)"\
	|sed -e "s/^\s*//" -e 's/^\([^:]*\):/\1\t/' -e "s/DNS://g" -e "s/^/${HO}${PO}\t/"

	echo -e "${HO}${PO}\tMD5\t$(<"${TMPDIR}/x509_text" openssl x509 -noout -modulus|openssl md5|sed -e "s/^[^ ]* //")"

	cleanUp
	echo
    read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
    return
}

# Menú principal
while true; do
    show_menu

    case $opcion in
        1) ping_option ;;
        2) nslookup_option ;;
        3) info_option ;;
        4) processes_option ;;
        5) users_option ;;
        6) arp_cache_option ;;
        7) connections_option ;;
        8) update_option ;;
        9) deldns_option ;;
		10) certssl_option ;;
        0) exit 0 ;;
        *)
            echo
			echo -e "${ROJO}Opción no válida.${RESET}"
			echo
            read -p $'\e[1;32mPresione [Enter] para continuar...\e[0m'
            ;;
    esac
done
