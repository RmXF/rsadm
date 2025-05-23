#!/bin/bash

## Desarrollador @ReyRs_ViPro

## SCRIPT RS CREACIONES POWERED BY FABIAN
## GENERADOR DE USUARIOS
## LENGUAGE _ BASH SCRIPT
## OPTIMIZADO AL ESPAÑOL POSIBLE TRADUCCION AUTOMATICA AL PORTUGUES !!!  Salud2s;)
## PAGINA WEB OFICIAL: www.reycodessh.tk


# A CONTINUACION COLORES Y VARIABLES 

GRN1='\e[32m [\e[0m1\e[32m]\e[0m';
GRN2='\e[32m [\e[0m2\e[32m]\e[0m';
GRN3='\e[32m [\e[0m3\e[32m]\e[0m';
GRN4='\e[32m [\e[0m4\e[32m]\e[0m';
GRN5='\e[32m [\e[0m5\e[32m]\e[0m';
GRN6='\e[32m [\e[0m6\e[32m]\e[0m';
GRN7='\e[32m [\e[0m7\e[32m]\e[0m';
GRN8='\e[32m [\e[0m8\e[32m]\e[0m';
GRN9='\e[32m [\e[0m9\e[32m]\e[0m';
GRN10='\e[32m [\e[0m10\e[32m]\e[0m';
GRN11='\e[32m [\e[0m11\e[32m]\e[0m';
GRN12='\e[32m [\e[0m12\e[32m]\e[0m';
GRN13='\e[32m [\e[0m13\e[32m]\e[0m';
GRN14='\e[32m [\e[0m14\e[32m]\e[0m';
GRN15='\e[32m [\e[0m15\e[32m]\e[0m';
GRN16='\e[32m [\e[0m16\e[32m]\e[0m';
GRN17='\e[32m [\e[0m17\e[32m]\e[0m';
GRN18='\e[32m [\e[0m18\e[32m]\e[0m';
GRN19='\e[32m [\e[0m19\e[32m]\e[0m';
GRN20='\e[32m [\e[0m20\e[32m]\e[0m';
GRN21='\e[32m [\e[0m21\e[32m]\e[0m';
GRN22='\e[32m [\e[0m22\e[32m]\e[0m';
GRN23='\e[32m [\e[0m23\e[32m]\e[0m';
GRN24='\e[32m [\e[0m24\e[32m]\e[0m';
GRN25='\e[32m [\e[0m25\e[32m]\e[0m';
blanco='\033[38;5;231m'
amarillo='\033[38;5;228m'
azul='\033[38;5;14m'
rojo='\033[0;31m'
verde='\033[38;5;148m'
resaltadorojo='\e[41;1;37m'
resaltadoazul='\e[44;1;37m'
cierre1='\e[0m'
cierre='\033[0m'
bar1="\e[1;30m◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚\e[0m"
bar2="\033[38;5;226m---------------------------------------------------------\033[0m"
bar3="\033[38;5;226m-------------------------------- ${blanco}=/${cierre}${rojo} ADMIN ${cierre}${blanco}\=${cierre} ${amarillo}-------------------------------${cierre}"
bar4="\033[38;5;14m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"

## VARIABLES DE ENTORNO Y SISTEMA
USRdatabase="/etc/RSdb"
USRfile="${USRdatabase}/usuarios.db"
mkdir -p "${USRdatabase}"
touch "${USRdatabase}/usuarios_creados.txt"
USREXP="/root/exp"
BANNER_DIR="/etc/rs-banners"
mkdir -p "$BANNER_DIR"

## TITULOS / LINK / 
TITLE='  REYCODESSH  ';
VERSION='  [ V2.9 ]  ';
## FUNCION DE ERRORES 
err_fun () {
     case $1 in
     1)echo -e "${rojo}Usuario Nulo"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     2)echo -e "${rojo}Usuario con nombre muy corto"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     3)echo -e "${rojo}Usuario con nombre muy grande"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     4)echo -e "${rojo}Contrasena Nula"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     5)echo -e "${rojo}Contrasena Muy corta"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     6)echo -e "${rojo}Contrasena Muy Grande"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     7)echo -e "${rojo}Duracion Nula"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     8)echo -e "${rojo}Duracion no valida utiliza numeros"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     9)echo -e "${rojo}Duracion maxima de un ano"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     11)echo -e "${rojo}Limite Nulo"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     12)echo -e "${rojo}Limite invalido utilize numeros"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     13)echo -e "${rojo}Limite maximo es de 999"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     14)echo -e "${rojo}Usuario Ya existe"; sleep 2s; tput cuu1; tput dl1; tput cuu1; tput dl1;;
     esac
}

## FUNCIONES NECESARIAS
sort ${USRdatabase} | uniq > ${USRdatabase}tmp
mv -f ${USRdatabase}tmp ${USRdatabase}
meu_ip () {
if [[ -e /etc/MEUIPADM ]]; then
echo "$(cat /etc/MEUIPADM)"
else
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && echo "$MEU_IP2" || echo "$MEU_IP"
echo "$MEU_IP2" > /etc/MEUIPADM
fi
}

mostrar_usuarios () {
    clear
    echo -e "\e[1;36m════════════════════════════════════════════════════"
    echo -e "           USUARIOS CREADOS DESDE ESTE SCRIPT"
    echo -e "════════════════════════════════════════════════════\e[0m"
    printf "%-12s %-12s %-12s %-12s %-8s\n" "USUARIO" "CONTRASEÑA" "FECHA" "T/RESTANTE" "LIMITE"
    echo -e "\e[1;34m────────────────────────────────────────────────────\e[0m"

    archivo_usuarios="${USRdatabase}/usuarios_creados.txt"

    if [ -f "$archivo_usuarios" ] && [ -s "$archivo_usuarios" ]; then
        while IFS= read -r user; do
            if id "$user" &>/dev/null && grep -qw "$user" "$USRfile"; then
                datos=$(grep -w "$user" "$USRfile")
                usuario=$(echo "$datos" | cut -d'|' -f1)
                contrasena="***"
                fecha=$(echo "$datos" | cut -d'|' -f3)
                limite=$(echo "$datos" | cut -d'|' -f4)

                hoy=$(date +%s)
                fecha_objetivo=$(date -d "$fecha" +%s 2>/dev/null)
                if [ $? -eq 0 ]; then
                    dias_restantes=$(( (fecha_objetivo - hoy) / 86400 ))
                    [ $dias_restantes -lt 0 ] && dias_restantes=0
                else
                    dias_restantes="?"
                fi

                printf "%-12s %-12s %-12s %-12s %-8s\n" "$usuario" "$contrasena" "$fecha" "[$dias_restantes]" "$limite"
            fi
        done < "$archivo_usuarios"
    else
        echo -e "\e[1;31mNo hay usuarios registrados por este script aún.\e[0m"
    fi

    echo ""
    read -p "➤ Presione ENTER para volver"
}


add_user () {
    [[ $(cat /etc/passwd | grep $1: | grep -vi [a-z]$1 | grep -v [0-9]$1 > /dev/null) ]] && return 1

    valid=$(date '+%C%y-%m-%d' -d " +$3 days") && datexp=$(date "+%F" -d " + $3 days")
    useradd -M -s /bin/false $1 -e ${valid} > /dev/null 2>&1 || return 1

    (echo $2; echo $2) | passwd $1 2>/dev/null || {
        userdel --force $1
        return 1
    }

    [[ -e ${USRfile} ]] && {
        newbase=$(cat ${USRfile} | grep -w -v "$1")
        echo "$1|$2|${datexp}|$4" > ${USRfile}
        for value in `echo ${newbase}`; do
            echo $value >> ${USRfile}
        done
    } || echo "$1|$2|${datexp}|$4" > ${USRfile}

    # REGISTRAR EL USUARIO EN LA LISTA DE CREADOS SI NO ESTÁ
    grep -qxF "$1" "${USRdatabase}/usuarios_creados.txt" || echo "$1" >> "${USRdatabase}/usuarios_creados.txt"
}


renew_user_fun () {
## RENOVACION DE USUARIOS
datexp=$(date "+%F" -d " + $2 days") && valid=$(date '+%C%y-%m-%d' -d " + $2 days")
chage -E $valid $1 2> /dev/null || return 1
[[ -e ${USRdatabase} ]] && {
   newbase=$(cat ${USRdatabase}|grep -w -v "$1")
   useredit=$(cat ${USRdatabase}|grep -w "$1")
   pass=$(echo $useredit|cut -d'|' -f2)
   limit=$(echo $useredit|cut -d'|' -f4)
   echo "$1|$pass|${datexp}|$limit" > ${USRdatabase}
   for value in `echo ${newbase}`; do
   echo $value >> ${USRdatabase}
   done
   }
}
edit_user_fun () {
## EDICION DE USUARIOS
(echo "$2" ; echo "$2" ) |passwd $1 > /dev/null 2>&1 || return 1
datexp=$(date "+%F" -d " + $3 days") && valid=$(date '+%C%y-%m-%d' -d " + $3 days")
chage -E $valid $1 2> /dev/null || return 1
[[ -e ${USRdatabase} ]] && {
   newbase=$(cat ${USRdatabase}|grep -w -v "$1")
   echo "$1|$2|${datexp}|$4" > ${USRdatabase}
   for value in `echo ${newbase}`; do
   echo $value >> ${USRdatabase}
   done
   } || echo "$1|$2|${datexp}|$4" > ${USRdatabase}
}
rm_user () {
## ELIMINA USUARIOS
userdel --force "$1" &>/dev/null || return 1
[[ -e ${USRdatabase} ]] && {
   newbase=$(cat ${USRdatabase}|grep -w -v "$1")
   for value in `echo ${newbase}`; do
   echo $value >> ${USRdatabase}
   done
   }
}

cleanreg () {
sudo rm -rf /etc/newadmin/ger-user/Limiter.log
}

#METODO y PROCOLOS

ssl_pay () {
    apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/RmXF/rsadm/main/autoinstalssl; chmod 777 autoinstalssl; ./autoinstalssl
}


bannerssh_rs() {
    clear
    echo -e "\033[1;32m═══════════════════════════════════════════════"
    echo -e "          CONFIGURADOR DE BANNER SSH"
    echo -e "═══════════════════════════════════════════════\033[0m"

    read -p "Texto del banner (se mostrará al iniciar sesión): " texto_banner

    # Ruta del archivo de banner
    BANNER_TXT="/etc/ssh/banner_rs.txt"

    # Crear el banner
    echo -e "\n$texto_banner\n" > "$BANNER_TXT"

    # Asegurar permisos
    chmod 644 "$BANNER_TXT"

    # Aplicar en sshd_config
    if grep -q "^Banner" /etc/ssh/sshd_config; then
        sed -i "s|^Banner.*|Banner $BANNER_TXT|" /etc/ssh/sshd_config
    else
        echo "Banner $BANNER_TXT" >> /etc/ssh/sshd_config
    fi

    # Reiniciar servicio SSH
    systemctl restart sshd &>/dev/null && \
    echo -e "\n\033[1;32m✔ Banner aplicado y SSH reiniciado correctamente.\033[0m" || \
    echo -e "\n\033[1;31m✖ Error al reiniciar SSH. Verifica manualmente.\033[0m"

    read -p "Presiona ENTER para volver al menú..."
}
editar_banner_dia() {
  local dia=$1
  local archivo="$BANNER_DIR/banner_${dia,,}" # minúsculas
  echo -e "\n📝 Escribe tu banner para el día $dia (Ctrl+O para guardar, Ctrl+X para salir):"
  nano "$archivo"
}

submenu_banners_dia() {
  while true; do
    clear
    echo -e "🔧 Configuración de Banners SSH por Día de la Semana\n"
    echo "1) Editar banner para Lunes"
    echo "2) Editar banner para Martes"
    echo "3) Editar banner para Miércoles"
    echo "4) Editar banner para Jueves"
    echo "5) Editar banner para Viernes"
    echo "6) Editar banner para Sábado"
    echo "7) Editar banner para Domingo"
    echo "8) Ver banners actuales"
    echo "9) Salir"
    read -p "Selecciona una opción: " op
    case $op in
      1) editar_banner_dia "lunes" ;;
      2) editar_banner_dia "martes" ;;
      3) editar_banner_dia "miercoles" ;;
      4) editar_banner_dia "jueves" ;;
      5) editar_banner_dia "viernes" ;;
      6) editar_banner_dia "sabado" ;;
      7) editar_banner_dia "domingo" ;;
      8) ls -1 "$BANNER_DIR"; read -p "Presiona ENTER para continuar..." ;;
      9) break ;;
      *) echo "❌ Opción inválida"; sleep 1 ;;
    esac
  done
}

# 🔁 Script para aplicar el banner correcto según el día
echo '#!/bin/bash
BANNER_DIR="/etc/rs-banners"
DIA=$(date +"%A" | tr "[:upper:]" "[:lower:]")
BANNER_FILE="$BANNER_DIR/banner_$DIA"
if [[ -f "$BANNER_FILE" ]]; then
  cp "$BANNER_FILE" /etc/banner_actual
  sed -i "/^Banner /d" /etc/ssh/sshd_config
  echo "Banner /etc/banner_actual" >> /etc/ssh/sshd_config
  systemctl reload sshd
fi' > /usr/local/bin/aplicar_banner_ssh
chmod +x /usr/local/bin/aplicar_banner_ssh

# 🕘 Agregar cron para ejecutar el script cada día a las 00:01
(crontab -l 2>/dev/null; echo "1 0 * * * /usr/local/bin/aplicar_banner_ssh") | crontab -





	


# admin udp ( Funcion no disponible aún )

udp () {
clear
echo -e "\033[1;31m================================================================\033[0m"
echo -ne "${amarillo}[${cierre}${rojo}1${cierre}${amarillo}]${cierre} - ACTIVAR PUERTO BADVPN $fun_udp1\n" 
echo -ne "${amarillo}[${cierre}${rojo}1${cierre}${amarillo}]${cierre} - DESINSTALAR PUERTO BADVPN fun_udp2\n" 
echo -e "\033[1;31m================================================================\033[0m"
}


# BARRAS DE ESPERAS
espera () {
          comando[0]="$1"
          comando[1]="$2"
          (
          [[ -e $HOME/fim ]] && rm $HOME/fim
          ${comando[0]} > /dev/null 2>&1
          ${comando[1]} > /dev/null 2>&1
          touch $HOME/fim
          ) > /dev/null 2>&1 &
          tput civis
		  echo -e "\033[1;31m===========================================================\033[1;37m"
          echo -ne "\n AGUARDE... ["
for i in {1..10}; do
    echo -ne "🟩"
    sleep 0.1
done
for i in {1..10}; do
    echo -ne "⬜"
    sleep 0.05
done
         [[ -e $HOME/fim ]] && rm $HOME/fim && break
         echo -e "${col5}"
         sleep 1s
         tput cuu1
         tput dl1
         echo -ne "\033[1;37m    UN MOMENTO...\033[1;35m["
         done
         echo -e "\033[1;35m]\033[1;37m -\033[1;32m LINK ENCONTRADO !\033[1;37m"
         sleep 1s
         tput cnorm
		 echo -e "\033[1;31m===========================================================\033[1;37m"
        }


# BARRAS DE ESPERAS
fun_bar () {
          comando[0]="$1"
          comando[1]="$2"
          (
          [[ -e $HOME/fim ]] && rm $HOME/fim
          ${comando[0]} > /dev/null 2>&1
          ${comando[1]} > /dev/null 2>&1
          touch $HOME/fim
          ) > /dev/null 2>&1 &
          tput civis
		  echo -e "\033[1;31m===========================================================\033[1;37m"
          echo -ne "\n AGUARDE... ["
for i in {1..10}; do
    echo -ne "🟩"
    sleep 0.1
done
for i in {1..10}; do
    echo -ne "⬜"
    sleep 0.05
done
         echo -e "\033[1;35m]\033[1;37m -\033[1;32m TODO OK !\033[1;37m"
         sleep 1s
         tput cnorm
		 echo -e "\033[1;31m===========================================================\033[1;37m"
        }




autm=$(grep  "menu;"  /etc/profile > /dev/null && echo -e  "\033[1;32m◉ "  || echo -e  "\033[1;31m○ ") 


#ACTUALIZACION Y DESISTALACION
actualizar_fun () {
clear
echo ""
echo -e "\033[1;31m===========================================================\033[1;37m"
echo -e " ${verde}[ Buscando link de actualizacion ]${cierre}"
espera  'ACTUALIZACION'
apt-get update -y > /dev/null 2>&1 
apt-get upgrade -y > /dev/null 2>&1 
rm -rf $HOME/panelrs.sh; wget https://raw.githubusercontent.com/RmXF/rsadm/main/panelrs.sh; chmod 755 *; mv panelrs.sh /usr/bin/usercode; usercode
echo ""
}

#DETALLES DEL SISTEMA

_core=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
_usop=$(printf '%-1s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")

ram1=$(free -h | grep -i mem | awk {'print $2'})

_ram=$(printf ' %-9s' "$(free -h | grep -i mem | awk {'print $2'})")
_usor=$(printf '%-8s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")

os_system () {
system=$(echo $(cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/      //'))
echo $system|awk '{print $1, $2}'
}

meu_ip () {
if [[ -e /etc/MEUIPADM ]]; then
echo "$(cat /etc/MEUIPADM)"
else
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && echo "$MEU_IP2" || echo "$MEU_IP"
echo "$MEU_IP2" > /etc/MEUIPADM
fi
}
fun_ip () {
if [[ -e /etc/MEUIPADM ]]; then
IP="$(cat /etc/MEUIPADM)"
else
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
echo "$MEU_IP2" > /etc/MEUIPADM
fi
}

BadVPN () {
pid_badvpn=$(ps x | grep badvpn | grep -v grep | awk '{print $1}')
if [ "$pid_badvpn" = "" ]; then
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[7;35             Que puerto desea utilizar?      \e[0m"
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p " [Predeterminado]: " -e -i 7300 udpport
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[7;35  "Puerto seleccionado")  ${udpport}"
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[7;35             ACTIVADOR DE BADVPN (UDP ${udpport})         \e[0m"
    echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    if [[ ! -e /bin/badvpn-udpgw ]]; then
    wget -O /bin/usercode https://www.dropbox.com/s/z6hm10p3307un5m/badvpn-udpgw &>/dev/null
    chmod 777 /bin/badvpn-udpgw
    fi
    screen -dmS badvpn2 /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10 
    [[ "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] && "              ACTIVADO CON EXITO     " ||  "     Fallo al activar badvpn  "
	echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
else
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\e[7;35         DESACTIVADOR DE BADVPN (UDP 7300)             \e[0m"
    echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    kill -9 $(ps x | grep badvpn | grep -v grep | awk '{print $1'}) > /dev/null 2>&1
    killall badvpn-udpgw > /dev/null 2>&1
    [[ ! "$(ps x | grep badvpn | grep -v grep | awk '{print $1}')" ]] &&  "   DESACTIVADO CON EXITO \n    "
    unset pid_badvpn
	echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    fi
unset pid_badvpn
}

monitor () {
clear
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[41;1;37m SISTEMAS      CANTIDAD         USO              IP          \E[0m"
echo -e "\e[7;35  CPU ➛ \e[0m           \033[1;93m$_core\e[0m               \033[1;32m$_usop\e[0m     \e[33;1;34m  $(meu_ip) \e[0m"
echo -e "\e[7;35  RAM ➛ \e[0m          \033[1;93m$ram1\e[0m           \033[1;32m$_usor\e[0m"
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[7;35m         Su Sistema Operativo es: $(os_system)          \e[0m "
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p " ➢ Presione enter para volver "
rm -rf /etc/usr/bin/usercode; usercode
}


eliminar_script () {
clear
clear 
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                ¿ DESEA DESINSTALAR SCRIPT ?                  "
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
while [[ ${yesno} != @(s|S|y|Y|n|N) ]]; do
read -p " [S/N]: " yesno
tput cuu1 && tput dl1
done
if [[ ${yesno} = @(s|S|y|Y) ]]; then
rm -rf ${SCPdir} &>/dev/null
rm -rf ${SCPusr} &>/dev/null
rm -rf ${SCPinst} &>/dev/null
[[ -e /bin/usercode ]] && rm /bin/usercode
[[ -e /usr/bin/usercode ]] && rm /usr/bin/usercode
[[ -e /bin/menu ]] && rm /bin/menu
[[ -e /usr/bin/menu ]] && rm /usr/bin/menu
cd $HOME
fi
sudo apt-get --purge remove squid -y > /dev/null 2>&1
sudo apt-get --purge remove stunnel4 -y > /dev/null 2>&1
sudo apt-get --purge remove dropbear -y > /dev/null 2>&1
sudo apt-get --purge remove v2ray -y > /dev/null 2>&1
}




#LIMPIEZA
caches () {
clear
(
VE="" && MA="" && DE=""
while [[ ! -e /tmp/abc ]]; do
A+="#"
echo -e "${VE}[${MA}${A}${VE}]" >&2
sleep 0.4s
tput cuu1 && tput dl1
done
echo -e "${VE}[${MA}${A}${VE}] - ${MA}[100%]\n" >&2
rm /tmp/abc
) &
echo 3 > /proc/sys/vm/drop_caches &>/dev/null
sleep 1s
sysctl -w vm.drop_caches=3 &>/dev/null
apt-get autoclean -y &>/dev/null
sleep 1s
apt-get clean -y &>/dev/null
rm /tmp/* &>/dev/null
touch /tmp/abc
sleep 0.2s
echo -ne "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
echo -ne "${azul}LIMPIEZA COMPLETADA...${cierre}\n"
echo -ne "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
read -p " ➢ Presione enter para volver "
rm -rf /etc/usr/bin/usercode; usercode
}


#Copia de seguridad para usuarios
backup () {
clear
echo -ne "${azul}HERRAMIENTA DE BACKUP DE USUARIOS\n${cierre}"
echo -ne "$bar2\n"
echo -ne "${amarillo}[${cierre}${rojo}1${cierre}${amarillo}]${cierre} - CREAR COPIA DE USUARIO\n" 
echo -ne "${amarillo}[${cierre}${rojo}2${cierre}${amarillo}]${cierre} - RESTAURAR BACKUP\n"
echo -e "$bar2"
unset selection
while [[ ${selection} != @([1-2]) ]]; do
echo -ne "${amarillo}"Seleccione una Opcion" " && read selection
tput cuu1 && tput dl1
done
case ${selection} in
1)
cp ${USRdatabase} $HOME/Backup-adm
echo -e "${verde}Copia de Seguridad generada con exito ${cierre}"
echo -e "${amarillo}Su copia de seguridad se encuentra en la siguiente ruta"${cierre}" ${rojo}>${cierre} ${verde}$HOME/Backup-adm${cierre}"
echo -e "$bar2"
;;
2)
while [[ ! -e ${dirbackup} ]]; do
echo -ne "${azul} Escriba la ubicacion de la copia de seguridad\n${cierre}" 
echo -ne "${blanco} ENTER para ruta predeterminada /root/Backup-adm: ${cierre}" && read dirbackup
echo -e "$bar2"
[[ -z "${dirbackup}" ]] && dirbackup="/root/Backup-adm"
tput cuu1 && tput dl1
done
VPSsec=$(date +%s)
while read line; do
nome=$(echo ${line}|cut -d'|' -f1)
[[ $(echo $(mostrar_usuarios)|grep -w "$nome") ]] && { ${rojo} "$nome [ERROR]${cierre}"
  continue
  }
senha=$(echo ${line}|cut -d'|' -f2)
DateExp=$(echo ${line}|cut -d'|' -f3)
DataSec=$(date +%s --date="$DateExp")
[[ "$VPSsec" -lt "$DataSec" ]] && dias="$(($(($DataSec - $VPSsec)) / 86400))" || dias="NP"
limite=$(echo ${line}|cut -d'|' -f4)
add_user "$nome" "$senha" "$dias" "$limite" &>/dev/null && ${verde} "$nome [CUENTA VALIDA]${cerrar}" || ${rojo} "$nome [CUENTA INVALIDA FECHA EXPIRADA]${cerrar}"
done < ${dirbackup}
;;
esac
read -p " ➢ Presione enter para volver "
rm -rf $HOME//etc/usr/bin/usercode; usercode
}

nuevo_usuario () {
usuarios_ativos=($(mostrar_usuarios))
if [[ -z ${usuarios_ativos[@]} ]]; then
clear
echo -e "$bar1"
echo -e " ⚠️ SE RECOMIENDA HACER LOS USUARIOS  CON 7 LETRAS PARA TENER UN MEJOR ORDEN EN VISUALIZACION ⚠️ "
echo -e "$bar1"
echo -e "${rojo}Ningun usuario registrado${cierre}"
echo -e "$bar1"
else
clear
echo -e "$bar1"
echo -e "⚠️ SE RECOMIENDA HACER LOS USUARIOS  CON 7 LETRAS PARA TENER UN MEJOR ORDEN EN VISUALIZACION ⚠️ "
echo -e "$bar1"
echo -e "${azul}Usuarios actualmente activos en el servidor${cierre}"
echo -e "$bar1"
for us in $(echo ${usuarios_ativos[@]}); do
echo -ne "${blanco}Usuario: ${cierre}" && echo -e "${amarillo}${us}${cierre}"
done
echo -e "$bar1"
fi
while true; do
     echo -ne "${blanco}Nombre del nuevo usuario${cierre}"
     read -p ": " nomeuser
     nomeuser="$(echo $nomeuser|sed -e 's/[^a-z0-9 -]//ig')"
     if [[ -z $nomeuser ]]; then
     err_fun 1 && continue
     elif [[ "${#nomeuser}" -lt "2" ]]; then
     err_fun 2 && continue
     elif [[ "${#nomeuser}" -gt "30" ]]; then
     err_fun 3 && continue
     elif [[ "$(echo ${usuarios_ativos[@]}|grep -w "$nomeuser")" ]]; then
     err_fun 14 && continue
     fi
     break
done
while true; do
     echo -ne "${blanco}Contrasena Para El Nuevo usuario${cierre}"
     read -p ": " senhauser
     if [[ -z $senhauser ]]; then
     err_fun 4 && continue
     elif [[ "${#senhauser}" -lt "2" ]]; then
     err_fun 5 && continue
     elif [[ "${#senhauser}" -gt "30" ]]; then
     err_fun 6 && continue
     fi
     break
done
while true; do
     echo -ne "${blanco}Tiempo de Duracion del nuevo usuario${cierre}"
     read -p ": " diasuser
     if [[ -z "$diasuser" ]]; then
     err_fun 7 && continue
     elif [[ "$diasuser" != +([0-9]) ]]; then
     err_fun 8 && continue
     elif [[ "$diasuser" -gt "360" ]]; then
     err_fun 9 && continue
     fi 
     break
done
while true; do
     echo -ne "${blanco}Limite de conexion del nuevo usuario${cierre}"
     read -p ": " limiteuser
     if [[ -z "$limiteuser" ]]; then
     err_fun 11 && continue
     elif [[ "$limiteuser" != +([0-9]) ]]; then
     err_fun 12 && continue
     elif [[ "$limiteuser" -gt "999" ]]; then
     err_fun 13 && continue
     fi
     break
done
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     echo -ne "${amarillo}IP del servidor: " && echo -e "${blanco}$(meu_ip)${cierre}"
     echo -ne "${amarillo}Usuario: " && echo -e "${blanco}$nomeuser${cierre}"
     echo -ne "${amarillo}contrasena: " && echo -e "${blanco}$senhauser"
     echo -ne "${amarillo}Dias de Duracion: " && echo -e "${blanco}$diasuser${cierre}"
     echo -ne "${amarillo}Fecha de expiracion: " && echo -e "$(date "+%F" -d " + $diasuser days")"
     echo -ne "${amarillo}Limite de conexion: " && echo -e "${blanco}$limiteuser${cierre}"
echo -e "$bar1"
add_user "${nomeuser}" "${senhauser}" "${diasuser}" "${limiteuser}" && echo -e "${verde}Usuario creado con exito${cierre}" || echo -e "${rojo}Error, Usuario no creado!!${cierre}"
[[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && newclient "$nomeuser" "$senhauser"
echo -e  "$bar 1" 
read -p  " ➢ Presione enter para volver " 
rm -rf /etc/usr/bin/usercode; usercode
}


eliminar_usuario () {
usuarios_ativos=($(mostrar_usuarios))
if [[ -z ${usuarios_ativos[@]} ]]; then
echo -e "${rojo}Ningun usuario registrado${cierre}"
echo -e "$bar1"
return 1
else
echo -e "${amarillo}Usuarios actualmente activos en el servidor${cierre}"
echo -e "$bar1"
i=0
for us in $(echo ${usuarios_ativos[@]}); do
echo -ne "[$i] ->" && echo -e "\033[1;33m ${us}"
let i++
done
echo -e "$bar1"
fi
echo -e "${blanco}Escriba o seleccione un usuario${cierre}"
echo -e "$bar1"
unset selection
while [[ -z ${selection} ]]; do
echo -ne "\033[1;37mSeleccione una opcion: " && read selection
tput cuu1 && tput dl1
done
if [[ ! $(echo "${selection}" | egrep '[^0-9]') ]]; then
usuario_del="${usuarios_ativos[$selection]}"
else
usuario_del="$selection"
fi
[[ -z $usuario_del ]] && {
     echo -e "${rojo}Error, Usuario Invalido${cierre}"
     echo -e "$bar1"
     return 1
     }
[[ ! $(echo ${usuarios_ativos[@]}|grep -w "$usuario_del") ]] && {
     echo -e "${rojo}Error, Usuario Invalido${cierre}"
     echo -e "$bar1"
     return 1
     }
echo -ne "${blanco}Usuario Selecionado: " && echo -ne "$usuario_del"
rm_user "$usuario_del" && echo -e "${verde} [Eliminado]${blanco}" || echo -e "${rojo} [No Eliminado]${cierre}"
sed -i "/$usuario_del/d" $USRdatabase
echo -e  "$bar 1" 
read -p  " ➢ Presione enter para volver " 
rm -rf /etc/usr/bin/usercode; usercode
}


renovar_usuario () {
usuarios_ativos=($(mostrar_usuarios))
if [[ -z ${usuarios_ativos[@]} ]]; then
echo -e "${rojo}Ningun usuario registrado${cierre}"
echo -e "$bar1"
return 1
else
echo -e "${amarillo}Usuarios actualmente activos en el servidor${cierre}"
echo -e "$bar1"
i=0
for us in $(echo ${usuarios_ativos[@]}); do
echo -ne "[$i] ->" && echo -e "\033[1;33m ${us}"
let i++
done
echo -e "$bar1"
fi
echo -e "${amarillo}Escriba o seleccione un usuario${cierre}"
echo -e "$bar1"
unset selection
while [[ -z ${selection} ]]; do
echo -ne "\033[1;37mSeleccione la opcion: " && read selection
tput cuu1
tput dl1
done
if [[ ! $(echo "${selection}" | egrep '[^0-9]') ]]; then
useredit="${usuarios_ativos[$selection]}"
else
useredit="$selection"
fi
[[ -z $useredit ]] && {
     echo -e "${rojo}Error, Usuario Invalido${cierre}"
     echo -e "$bar1"
     return 1
     }
[[ ! $(echo ${usuarios_ativos[@]}|grep -w "$useredit") ]] && {
     echo -e "${rojo}Error, Usuario Invalido${cierre}"
     echo -e "$bar1"
     return 1
     }
while true; do
     echo -ne "${amarillo}Nuevo Tiempo de Duracion de: $useredit${cierre}"
     read -p ": " diasuser
     if [[ -z "$diasuser" ]]; then
     echo -e '\n\n\n'
     err_fun 7 && continue
     elif [[ "$diasuser" != +([0-9]) ]]; then
     echo -e '\n\n\n'
     err_fun 8 && continue
     elif [[ "$diasuser" -gt "360" ]]; then
     echo -e '\n\n\n'
     err_fun 9 && continue
     fi
     break
done
echo -e "$bar1"
renew_user_fun "${useredit}" "${diasuser}" && echo -e "${verde}Usuario Modificado Con Exito!!!${cierre}" || echo -e "${rojo}Error, Usuario no modificado${cierre}"
echo -e  "$bar 1" 
read -p  " ➢ Presione enter para volver " 
rm -rf /etc/usr/bin/usercode; usercode
}

editar_usuario () {
usuarios_ativos=($(mostrar_usuarios))
if [[ -z ${usuarios_ativos[@]} ]]; then
echo -e "${amarillo}Ningun usuario registrado${cierre}"
echo -e "$bar1"
return 1
else
echo -e "${azul}Usuarios Actualmente activos en el servidor${cierre}"
echo -e "$bar1"
i=0
for us in $(echo ${usuarios_ativos[@]}); do
echo -ne "[$i] ==>" && echo -e "\033[1;33m ${us}"
let i++
done
echo -e "$bar1"
fi
echo -e "${blanco}Escriba o seleccione un usuario${cierre}"
echo -e "$bar1"
unset selection
while [[ -z ${selection} ]]; do
echo -ne "\033[1;37mSeleccione la opcion: " && read selection
tput cuu1; tput dl1
done
if [[ ! $(echo "${selection}" | egrep '[^0-9]') ]]; then
useredit="${usuarios_ativos[$selection]}"
else
useredit="$selection"
fi
[[ -z $useredit ]] && {
     echo -e "${rojo}Error, Usuario Invalido${cierre}"
     echo -e "$bar1"
     return 1
     }
[[ ! $(echo ${usuarios_ativos[@]}|grep -w "$useredit") ]] && {
     echo -e "${rojo}Error, Usuario Invalido${rojo}"
     echo -e "$bar1"
     return 1
     }
while true; do
echo -ne "${blanco}Usuario Selecionado: " && echo -e "$useredit"
     echo -ne "${blanco}Nueva Contrasena de: $useredit"
     read -p ": " senhauser
     if [[ -z "$senhauser" ]]; then
     err_fun 4 && continue
     elif [[ "${#senhauser}" -lt "2" ]]; then
     err_fun 5 && continue
     elif [[ "${#senhauser}" -gt "30" ]]; then
     err_fun 6 && continue
     fi
     break
done
while true; do
     echo -ne "${blanco}Dias de Duracion de: $useredit"
     read -p ": " diasuser
     if [[ -z "$diasuser" ]]; then
     err_fun 7 && continue
     elif [[ "$diasuser" != +([0-9]) ]]; then
     err_fun 8 && continue
     elif [[ "$diasuser" -gt "360" ]]; then
     err_fun 9 && continue
     fi
     break
done
while true; do
     echo -ne "${blanco}Nuevo Limite de Conexion de: $useredit"
     read -p ": " limiteuser
     if [[ -z "$limiteuser" ]]; then
     err_fun 11 && continue
     elif [[ "$limiteuser" != +([0-9]) ]]; then
     err_fun 12 && continue
     elif [[ "$limiteuser" -gt "999" ]]; then
     err_fun 13 && continue
     fi
     break
done
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     echo -ne "${blanco}Usuario: " && echo -e "$useredit"
     echo -ne "${blanco}Contrasena: " && echo -e "$senhauser"
     echo -ne "${blanco}Dias de Duracion: " && echo -e "$diasuser"
     echo -ne "${blanco}Fecha de expiracion: " && echo -e "$(date "+%F" -d " + $diasuser days")"
     echo -ne "${blanco}Limite de conexion: " && echo -e "$limiteuser"
echo -e "$bar1"
edit_user_fun "${useredit}" "${senhauser}" "${diasuser}" "${limiteuser}" && echo -e "${verde}Usuario Modificado Con Exito${cierre}" || echo -e "${rojo}Error, Usuario no modificado${cierre}"
echo -e "$bar1"
read -p  " ➢ Presione enter para volver " 
rm -rf /etc/usr/bin/usercode; usercode
}


detalles_de_usuario () {
clear
red=$(tput setaf 1)
gren=$(tput setaf 2)
yellow=$(tput setaf 3)
if [[ ! -e "${USRdatabase}" ]]; then
echo -e "${rojo}No se ha identificado una base de datos con usuarios${cierre}"
echo -e "${rojo}Los usuarios a seguir no contienen ninguna informacion${cierre}"
echo -e "$bar1"
fi
echo -e "$bar4"
txtvar=$(printf '%-16s' "USUARIO")
txtvar+=$(printf '%-16s' "CONTRASENA")
txtvar+=$(printf '%-16s' "FECHA")
txtvar+=$(printf '%-16s' "T/RESTANTE")
txtvar+=$(printf '%-16s' "LIMITE")
echo -e "\033[1;33m${txtvar}"
echo -e "$bar4"
VPSsec=$(date +%s)
while read user; do
unset txtvar
data_user=$(chage -l "$user" |grep -i co |awk -F ":" '{print $2}')
txtvar=$(printf '%-21s' "${yellow}$user")
if [[ -e "${USRdatabase}" ]]; then
  if [[ $(cat ${USRdatabase}|grep -w "${user}") ]]; then
    txtvar+="$(printf '%-21s' "${yellow}$(cat ${USRdatabase}|grep -w "${user}"|cut -d'|' -f2)")"
    DateExp="$(cat ${USRdatabase}|grep -w "${user}"|cut -d'|' -f3)"
    DataSec=$(date +%s --date="$DateExp")
    if [[ "$VPSsec" -gt "$DataSec" ]]; then    
    EXPTIME="${resaltadorojo}[Exp]${cierre1}"
    else
    EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
    fi
    echo -e "$bar4"
    #txtvar+="$(printf '%-26s' "${yellow}${DateExp}${EXPTIME}")"
    txtvar+="$(printf '%-26s' "${yellow}${DateExp}")"
    txtvar+="$(printf '%-18s' "${EXPTIME}")"
    txtvar+="$(printf '%-11s' "${yellow}$(cat ${USRdatabase}|grep -w "${user}"|cut -d'|' -f4)")"
    else
    txtvar+="$(printf '%-21s' "${red}***")"
    txtvar+="$(printf '%-21s' "${red}***")"
    txtvar+="$(printf '%-11s' "${red}***")"
  fi
fi
echo -e "$txtvar"
done <<< "$(mostrar_usuarios)"
echo -e  "$bar4" 
read -p  " ➢ Presione enter para volver " 
rm -rf /etc/usr/bin/usercode; usercode
}

monit_user () {
clear
yellow=$(tput setaf 3)
gren=$(tput setaf 2)
echo -e  "$bar4"
txtvar=$(printf  '%-17s'   "USUARIO") 
txtvar+=$(printf  '%-23s'   "ESTATUS") 
txtvar+=$(printf  '%-19s'   "CONEXION") 
txtvar+=$(printf  '%-19s'   "TIEMPO ONLINE") 
echo -e "\033[1;33m${txtvar}"
echo -e  "$bar4"
while read user; do
 _=$(
PID="0+"
[[ $(dpkg --get-selections|grep -w "openssh"|head -1) ]] && PID+="$(ps aux|grep -v grep|grep sshd|grep -w "$user"|grep -v root|wc -l)+"
[[ $(dpkg --get-selections|grep -w "dropbear"|head -1) ]] && PID+="$(dropbear_pids|grep -w "${user}"|wc -l)+"
[[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && [[ $(openvpn_pids|grep -w "$user"|cut -d'|' -f2) ]] && PID+="$(openvpn_pids|
grep -w "$user"|cut -d'|' -f2)+"
PID+="0"
TIMEON="${TIMEUS[$user]}"
[[ -z $TIMEON ]] && TIMEON=0
MIN=$(($TIMEON/60))
SEC=$(($TIMEON-$MIN*60))
HOR=$(($MIN/60))
MIN=$(($MIN-$HOR*60))
HOUR="${HOR}h:${MIN}m:${SEC}s"
[[ -z $(cat ${USRdatabase}|grep -w "${user}") ]] && MAXUSER="**" || MAXUSER="$(cat ${USRdatabase}|grep -w "${user}"|cut -d'|' -f4)"
[[ $(echo $PID|bc) -gt 0 ]] && user="$user         [${verde}ONLINE${cierre}]" || user="$user         [${rojo}OFLINE${cierre}]"
TOTALPID="$(echo $PID|bc)/$MAXUSER"
 while [[ ${#user} -lt 59 ]]; do
 user=$user" "
 done
 while [[ ${#TOTALPID} -lt 19 ]]; do
 TOTALPID=$TOTALPID" "
 done
 while [[ ${#HOUR} -lt 15 ]]; do
 HOUR=$HOUR" "
 done
echo -e "${yellow}$user $TOTALPID $HOUR" >&2
) &
pid=$!
sleep 0.5s
done <<< "$(mostrar_usuarios)"
while [[ -d /proc/$pid ]]; do
sleep 1s
done
echo -e  "$bar4"
}

No_user="$(cat /etc/RSdb | wc -l)"

menu () {
clear
on="\033[1;92m[ON]" && off="\033[1;31m[OFF]"
[[ $(ps x | grep badvpn | grep -v grep | awk '{print $1}') ]] && badvpn=$on || badvpn=$off
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[44;1;37m                              $TITLE                     $VERSION \e[0m "
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "${verde}CUENTAS SSH - DROPLET - SCRIPT - APK MOD - DISEÑO WEB ( ${rojo}dev:${cierre} ${melon}@ReyRs_ViPro${cierre} )
${bar3}
${blanco}[${cierre}${rojo}01${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Agregar  ${amarillo}===============${cierre}${blanco}>>${cierre} ${verde}Usuario${cierre}
${blanco}[${cierre}${rojo}02${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Eliminar ${amarillo}===============${cierre}${blanco}>>${cierre} ${rojo}Usuario${cierre}
${blanco}[${cierre}${rojo}03${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Editar   ${amarillo}===============${cierre}${blanco}>>${cierre} ${amarillo}Usuario${cierre}
${blanco}[${cierre}${rojo}04${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Renovar  ${amarillo}===============${cierre}${blanco}>>${cierre} ${verde}Usuarios${cierre}
${blanco}[${cierre}${rojo}05${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Informacion de  ${amarillo}========${cierre}${blanco}>>${cierre} ${amarillo}Usuarios${cierre}
${blanco}[${cierre}${rojo}06${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Usuarios  ${amarillo}==============${cierre}${blanco}>>${cierre} ${azul}Onlines${cierre}
${blanco}[${cierre}${rojo}07${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Actualizar  ${amarillo}============${cierre}${blanco}>>${cierre} ${verde}script${cierre}
${blanco}[${cierre}${rojo}08${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Desistalar  ${amarillo}============${cierre}${blanco}>>${cierre} ${rojo}script${cierre}
${blanco}[${cierre}${rojo}09${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Limpiar memoria  ${amarillo}=======${cierre}${blanco}>>${cierre} ${amarillo}cache${cierre}
${blanco}[${cierre}${rojo}10${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Detalles de la  ${amarillo}========${cierre}${blanco}>>${cierre} ${azul}maquina${cierre}
${blanco}[${cierre}${rojo}11${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Crear copia de  ${amarillo}========${cierre}${blanco}>>${cierre} ${verde}usuarios${cierre}
${blanco}[${cierre}${rojo}12${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Instalar metodo  ${amarillo}=======${cierre}${blanco}>>${cierre} ${melon}SSL+PYT.D${cierre}
${blanco}[${cierre}${rojo}13${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Añadir banner  ${amarillo}=========${cierre}${blanco}>>${cierre} ${amarillo}ssh${cierre} 
${blanco}[${cierre}${rojo}14${cierre}${blanco}]${cierre} ${rojo}>${cierre} ${blanco}Configurar puerto  ${amarillo}=====${cierre}${blanco}>>${cierre} ${amarillo}BadVpn${cierre}
${blanco}[${cierre}${rojo}0${cierre}${blanco}]${cierre} ${rojo}>>>${cierre} ${resaltadorojo} SALIR ${cierre1}
${bar4}"
read -p "$(echo -e "${blanco}seleccione [0-13]:${cierre}")" selection
case "$selection" in
1)nuevo_usuario ;;
2)eliminar_usuario ;;
3)editar_usuario ;;
4)renovar_usuario ;;
5)detalles_de_usuario ;;
6)monit_user ;;
7)actualizar_fun ;;
8)eliminar_script ;;
9)caches ;;
10)monitor ;;
11)backup ;;
12)ssl_pay ;;
13)submenu_banners_dia ;;

14)BadVPN ;;
	0)cd $HOME && exit 0;;
	*)
	echo -e "${rojo} comando principal- usercode ${cierre}"
	;;
esac
}
menu
