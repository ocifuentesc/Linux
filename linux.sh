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
# - Fedora Workstation 40 ARM
# - Rocky Linux 9.4 ARM

# Función para mostrar el menú
show_menu() {
    clear
    echo
    echo "========================"
    echo "      MENU PRINCIPAL"
    echo "========================"
	echo
    echo "1.  PING a una IP o Dominio"
    echo "2.  NSLOOKUP a una IP o Dominio"
    echo "3.  Información del equipo"
    echo "4.  Listar procesos activos"
    echo "5.  Ver Usuarios del Sistema"
    echo "6.  Ver cache ARP"
    echo "7.  Mostrar las conexiones activas"
    echo "8.  Actualizar Sistema"
    echo "9.  Borrar caché DNS y Temporales"
	echo "10. Revisar Certificado SSL"
	echo "11. NMAP"
	echo
    echo "0.  Salir"
	echo
    echo "========================"
    read -p "Ingrese una opción (0-11): " opcion
}

# Función para manejar la opción 1
ping_option() {
    clear
    echo
    read -p "Ingrese dirección IP o Dominio: " ping_target
    echo
    ping -c 4 "$ping_target"
    echo
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 2
nslookup_option() {
    clear
    echo
    read -p "Ingrese dirección IP o Dominio: " nslookup_target
    echo
    nslookup "$nslookup_target"
    echo
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 3
info_option() {
    # Detectamos el sistema operativo
	unamestr="${OSTYPE//[0-9.]/}"
	os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")

    # Ejecución
    clear
	echo
	echo "============================"
	echo "Detectando Sistema Operativo"
	echo "============================"
	echo
	sleep 2
	echo "Sistema identificado como $os"
	sleep 2
	echo

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
	echo "=================================="
    echo "      INFORMACION DEL EQUIPO      "
    echo "=================================="
    echo
    uname -a
    echo
    cat /etc/os-*
    echo
	echo "======================"
    echo "  INFORMACION DE RED  "
    echo "======================"
    ip -c a
    echo
    echo "==========="
    echo "  MEMORIA  "
    echo "==========="
    free -mth
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
	echo "=================================="
    echo "      INFORMACION DEL EQUIPO      "
    echo "=================================="
	echo
	system_profiler SPHardwareDataType
    echo
    scutil --get HostName
	echo
	echo "======================"
    echo "  INFORMACION DE RED  "
    echo "======================"
	echo
	scutil --nwi
	echo
    echo "==========="
    echo "  MEMORIA  "
    echo "==========="
    sysctl hw.memsize
    echo
    top -l 1 | grep PhysMem
	;;

	#
	# Otros
	#
	(*)
	echo "Error: Arquitectura del Sistema Operativo NO soportada"
	echo
	;;

	esac
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 4
processes_option() {
    clear
    echo
    ps aux
    echo
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 5
users_option() {
    # Detectamos el sistema operativo
	os="Desconocido"
	unamestr="${OSTYPE//[0-9.]/}"
	os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")
    # Ejecución
    clear
	echo
	echo "============================"
	echo "Detectando Sistema Operativo"
	echo "============================"
	echo
	sleep 2
	echo "Sistema identificado como $os"
	sleep 2
	echo

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
    awk -F: '{ print $1}' /etc/passwd
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
    dscl . list /Users | grep -v '_'
	;;

	#
	# Otros
	#
	(*)
	echo "Error: Arquitectura del Sistema Operativo NO soportada"
	echo
	;;

	esac
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 6
arp_cache_option() {
    # Detectamos el sistema operativo
	os="Desconocido"
	unamestr="${OSTYPE//[0-9.]/}"
	os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")
    # Ejecución
    clear
	echo
	echo "============================"
	echo "Detectando Sistema Operativo"
	echo "============================"
	echo
	sleep 2
	echo "Sistema identificado como $os"
	sleep 2
	echo

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
    arp
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
    arp -a
	;;

	#
	# Otros
	#
	(*)
	echo "Error: Arquitectura del Sistema Operativo NO soportada"
	echo
	;;

	esac
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 7
connections_option() {
    # Detectamos el sistema operativo
	os="Desconocido"
	unamestr="${OSTYPE//[0-9.]/}"
	os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")
    # Ejecución
    clear
	echo
	echo "============================"
	echo "Detectando Sistema Operativo"
	echo "============================"
	echo
	sleep 2
	echo "Sistema identificado como $os"
	sleep 2
	echo

    case $os in
	#
	# Derivados de Debian y Red Hat
	#
	*Debian* | *Ubuntu* | *Kali* | *CentOS*| *Fedora* | *lmaLinux* | *Rocky* | *rch*)
    netstat -tuln
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
    netstat -an
	;;

	#
	# Otros
	#
	(*)
	echo "Error: Arquitectura del Sistema Operativo NO soportada"
	echo
	;;

	esac
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 8
update_option() {
   # Detectamos el sistema operativo
	os="Desconocido"
	unamestr="${OSTYPE//[0-9.]/}"
	os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")
    # Ejecución
    clear
	echo
	echo "============================"
	echo "Detectando Sistema Operativo"
	echo "============================"
	echo
	sleep 2
	echo "Sistema identificado como $os"
	sleep 2
	echo

    case $os in
    # Arch Linux
	*rch*)
	echo "Actualizando Sistema..."
	echo
	sudo pacman -Syyu
	echo
	echo "Sistema Actualizado"
	echo
	;;

	#
	# Derivados de Debian
	#
    *Debian* | *Ubuntu* | *Kali*)
    # Actualizamos la lista de paquetes disponibles y sus versiones en los repositorios
	echo "Descargando Lista de Repositorios..."
	echo
	sudo apt-get update -y
	echo
	# Actualizamos paquetes del sistema
	echo "Actualizando Sistema..."
	echo
	sudo apt upgrade -y && sudo apt dist-upgrade -y
	echo
	# Eliminamos del repositorio local, la caché, los paquetes de versiones antiguas e inútiles
	echo "Limpiando..."
	echo
	sudo apt autoremove -y && sudo apt autoclean
	echo
	# Proceso terminado
	echo "Sistema Actualizado"
	echo
	;;

    #
    # Derivados de Red Hat
    #
    *CentOS*| *Fedora* | *lmaLinux* | *Rocky*)
    # Actualizamos la lista de paquetes disponibles y sus versiones en los repositorios
	echo "Descargando Lista de Repositorios..."
	echo
	sudo yum update -y
	echo
	# Actualizamos paquetes del sistema
	echo "Actualizando Sistema..."
	echo
	sudo yum upgrade -y
	echo
	# Eliminamos del repositorio local, la caché, los paquetes de versiones antiguas e inútiles
	echo "Limpiando..."
	echo
	sudo yum clean all
	echo
	# Proceso terminado
	echo "Sistema Actualizado"
	echo
	;;

	#
	# MacOS
	#
	*darwin*)
    softwareupdate --all --install --force
    echo
	;;

	#
	# Otros
	#
	(*)
	echo "Error: Arquitectura del Sistema Operativo NO soportada"
	echo
	;;

	esac
    read -p "Presione [Enter] para continuar..."
}

# Función para manejar la opción 9
deldns_option() {
    # Detectamos el sistema operativo
	os="Desconocido"
	unamestr="${OSTYPE//[0-9.]/}"
	os=$( compgen -G "/etc/*release" > /dev/null  && cat /etc/*release | grep ^NAME | tr -d 'NAME="'  ||  echo "$unamestr")
    # Ejecución
    clear
	echo
	echo "============================"
	echo "Detectando Sistema Operativo"
	echo "============================"
	echo
	sleep 2
	echo "Sistema identificado como $os"
	sleep 2
	echo

    case $os in
	# Arch Linux
	*rch*)
	echo "Limpiando caches..."
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
    echo "Limpiando caché de APT..."
    sudo apt-get clean
    sudo apt-get autoremove --purge
    echo
    echo "Limpiando caché de la memoria..."
    sudo sync && sudo sysctl -w vm.drop_caches=3
    echo
    echo "Eliminar archivos de caché de usuario..."
    sudo rm -rf ~/.cache/*
    echo
    ;;

    #
    # Derivados de Red Hat
    #
    *CentOS*| *Fedora* | *lmaLinux* | *Rocky*)
    echo "Limpiando caché de APT..."
    sudo yum clean all
    sudo rm -rf /var/cache/yum
    echo
    echo "Limpiando caché de la memoria..."
    sudo sync && sudo sysctl -w vm.drop_caches=3
    echo
    echo "Eliminando archivos caché de usuario..."
    sudo rm -rf ~/.cache/*
    echo
    ;;

	#
	# MacOS
	#
	*darwin*)
    echo "Limpiando caché DNS..."
    sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
    echo
    echo "Eliminando archivos caché del sistema..."
    sudo rm -rf ~/Library/Caches/*
    sudo rm -rf /Library/Caches/*
    echo
    echo "Limpiando caché del sistema operativo..."
    sudo purge
    echo
	;;

	#
	# Otros
	#
	(*)
	echo "Error: Arquitectura del Sistema Operativo NO soportada"
	echo
	;;

	esac
    read -p "Presione [Enter] para continuar..."
}

## Función para manejar la opción 10 - Certificado SSL
certssl_option() {
	clear
	echo
	echo " ---> DEBES TENER INSTALADO openssl <---"
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
	    echo "  MODO DE USO"
		echo " -------------"
		echo
    	echo "  example.com               		# Verificar un dominio en el puerto 443 (HTTPS)"
		echo "  https://example.com       		# Verificar usando protocolo https en el puerto 443"
		echo "  https://example.com:8080  		# Verificar usando protocolo https en el puerto 8080"
		echo
		echo "  sub.example.com           		# Verificar un subdominio en el puerto 443"
		echo "  https://sub.example.com       	# Verificar un subdominio https en el puerto 443"
		echo "  https://sub.example.com:8080  	# Verificar un subdominio https en el puerto 8080"
		echo
    	echo "  192.168.1.1               		# Verificar una dirección IP en el puerto 443 (HTTPS)"
    	echo "  https://192.168.1.1       		# Verificar una dirección IP en el puerto 443"
    	echo "  https://192.168.1.1:8080  		# Verificar una dirección IP en el puerto 8080 (HTTPS)"
		echo
		read -p "Introduce la IP o dominio a verificar: " H
		echo
	else
	    H="$1"
	fi

	PR="https://"
	PO=":443"
	URL="$(echo "${H}"|grep -oE "(${PROTOCOLS})?[^:/]*(:[0-9]*)?"|head -1)"
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
    read -p "Presione [Enter] para continuar..."
    return
}

## Función para manejar la opción 11 - NMAP
nmap_option() {
    while true; do
        clear
        echo
		echo " ---> DEBES TENER NMAP INSTALADO <---"
		echo
        echo "========================"
        echo "      MENU NMAP"
        echo "========================"
		echo
        echo "1.  Escaneo de Red"
		echo
        echo "0.  Volver al Menú Principal"
		echo
        echo "========================"
		echo
        read -p "Ingrese una opción (0-1): " opcionnmap

        case $opcionnmap in
            1) escaneo_de_red ;;
            0) return ;;
            *) 
                echo
				echo "Opción no válida."
				echo
                read -p "Presione [Enter] para continuar..."
                ;;
        esac
    done
}

# Función para escanear la red
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
        11) nmap_option ;;   # Submenú NMAP
        0) exit 0 ;;
        *)
            echo
			echo "Opción no válida."
			echo
            read -p "Presione [Enter] para continuar..."
            ;;
    esac
done
