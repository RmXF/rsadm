#!/bin/bash

## SCRIPT RS CREACIONES GENERENCIADOR DE USUARIOS


# COLORES Y BARRAS
blanco='\033[38;5;231m'
amarillo='\033[38;5;228m'
azul='\033[38;5;14m'
rojo='\033[0;31m'
verde='\033[38;5;148m'
cierre='\033[0m'
bar1="\e[1;30m◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚◚\e[0m"
bar2="\033[38;5;226m---------------------------------------------------------\033[0m"
bar3="\033[38;5;226m--------------------- = MENU = --------------------------\033[0m"
bar4="\033[0;31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
bar5="\033[38;5;14m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"


## VARIABLES DE ENTORNO Y SYSTEMA 
USRdatabase="/etc/RSdb"
USRExp="/root/exp"

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


#ACTUALIZACION Y DESISTALACION
actualizar_fun () {
echo ""
echo -e " \033[1;33m[ ☑ ] apt-get update -y "
apt-get update -y > /dev/null 2>&1 
echo -e " \033[1;33m[ ☑ ] apt-get upgrade -y "
apt-get upgrade -y > /dev/null 2>&1 
rm -rf $HOME/ADMbot.sh; wget https://raw.githubusercontent.com/RmXF/rsadm/main/ADMbot.sh; chmod 755 *; mv ADMbot.sh /usr/bin/usercode; usercode
echo ""
}

mostrar_usuarios () {
for u in `awk -F : '$3 > 900 { print $1 }' /etc/passwd | grep -v "nobody" |grep -vi polkitd |grep -vi system-`; do
echo "$u"
done
}

add_user () {
## FUNCION QUE AGRGA ALOS USUARIOS
[[ $(cat /etc/passwd |grep $1: |grep -vi [a-z]$1 |grep -v [0-9]$1 > /dev/null) ]] && return 1
valid=$(date '+%C%y-%m-%d' -d " +$3 days") && datexp=$(date "+%F" -d " + $3 days")
useradd -M -s /bin/false $1 -e ${valid} > /dev/null 2>&1 || return 1
(echo $2; echo $2)|passwd $1 2>/dev/null || {
    userdel --force $1
    return 1
    }
[[ -e ${USRdatabase} ]] && {
   newbase=$(cat ${USRdatabase}|grep -w -v "$1")
   echo "$1|$2|${datexp}|$4" > ${USRdatabase}
   for value in `echo ${newbase}`; do
   echo $value >> ${USRdatabase}
   done
   } || echo "$1|$2|${datexp}|$4" > ${USRdatabase}
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

nuevo_usuario () {
usuarios_ativos=($(mostrar_usuarios))
if [[ -z ${usuarios_ativos[@]} ]]; then
echo -e "${rojo}Ningun usuario registrado${cierre}"
echo -e "$bar1"
else
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
     elif [[ "${#nomeuser}" -lt "4" ]]; then
     err_fun 2 && continue
     elif [[ "${#nomeuser}" -gt "24" ]]; then
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
     elif [[ "${#senhauser}" -lt "6" ]]; then
     err_fun 5 && continue
     elif [[ "${#senhauser}" -gt "20" ]]; then
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
echo -e "$bar1"
read -p " ➢ Presione enter para volver "
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
echo -e "$bar1"
read -p " ➢ Presione enter para volver "
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
echo -e "$bar1"
read -p " ➢ Presione enter para volver "
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
echo -ne "[$i] ->" && echo -e "\033[1;33m ${us}"
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
     elif [[ "${#senhauser}" -lt "6" ]]; then
     err_fun 5 && continue
     elif [[ "${#senhauser}" -gt "20" ]]; then
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
read -p " ➢ Presione enter para volver "
rm -rf /etc/usr/bin/usercode; usercode
}


detalles_de_usuario () {
red=$(tput setaf 1)
gren=$(tput setaf 2)
yellow=$(tput setaf 3)
if [[ ! -e "${USRdatabase}" ]]; then
echo -e "${rojo}No se ha identificado una base de datos con usuarios${cierre}"
echo -e "${rojo}Los usuarios a seguir no contienen ninguna informacion${cierre}"
echo -e "$bar1"
fi
clear
echo -e "$bar1"
txtvar=$(printf '%-16s' "USUARIO")
txtvar+=$(printf '%-16s' "CONTRASENA")
txtvar+=$(printf '%-16s' "FECHA")
txtvar+=$(printf '%-6s' "LIMITE")
echo -e "\033[1;33m${txtvar}"
echo -e "$bar1"
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
    EXPTIME="${red}[Exp]"
    else
    EXPTIME="${gren}[$(($(($DataSec - $VPSsec)) / 86400))]"
    fi
    echo -e "$bar5"
    txtvar+="$(printf '%-26s' "${yellow}${DateExp}${EXPTIME}")"
    txtvar+="$(printf '%-11s' "${yellow}$(cat ${USRdatabase}|grep -w "${user}"|cut -d'|' -f4)")"
    else
    txtvar+="$(printf '%-21s' "${red}???")"
    txtvar+="$(printf '%-21s' "${red}???")"
    txtvar+="$(printf '%-11s' "${red}???")"
  fi
fi
echo -e "$txtvar"
done <<< "$(mostrar_usuarios)"
echo -e "$bar1"
}

monit_user () {
yellow=$(tput setaf 3)
gren=$(tput setaf 2)
echo -e "Monitor de Conexiones de Usuarios"
echo -e "${bar4}"
txtvar=$(printf '%-17s' "USUARIO")
txtvar+=$(printf '%-23s' "ESTATUS")
txtvar+=$(printf '%-19s' "CONEXION")
txtvar+=$(printf '%-8s' "TIEMPO ONLINE")
echo -e "\033[1;33m${txtvar}"
echo -e "${bar4}"
while read user; do
 _=$(
PID="0+"
[[ $(dpkg --get-selections|grep -w "openssh"|head -1) ]] && PID+="$(ps aux|grep -v grep|grep sshd|grep -w "$user"|grep -v root|wc -l)+"
[[ $(dpkg --get-selections|grep -w "dropbear"|head -1) ]] && PID+="$(dropbear_pids|grep -w "${user}"|wc -l)+"
[[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && [[ $(openvpn_pids|grep -w "$user"|cut -d'|' -f2) ]] && PID+="$(openvpn_pids|grep -w "$user"|cut -d'|' -f2)+"
PID+="0"
TIMEON="${TIMEUS[$user]}"
[[ -z $TIMEON ]] && TIMEON=0
MIN=$(($TIMEON/60))
SEC=$(($TIMEON-$MIN*60))
HOR=$(($MIN/60))
MIN=$(($MIN-$HOR*60))
HOUR="${HOR}h:${MIN}m:${SEC}s"
[[ -z $(cat ${USRdatabase}|grep -w "${user}") ]] && MAXUSER="-" || MAXUSER="$(cat ${USRdatabase}|grep -w "${user}"|cut -d'|' -f4)"
[[ $(echo $PID|bc) -gt 0 ]] && user="$user           [${verde}ONLINE${cierre}]" || user="$user           [${rojo}OFLINE${cierre}]"
echo -e "${bar4}"
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
sleep 3s
done
read -p " ➢ Presione enter para volver "
rm -rf /etc/usr/bin/usercode; usercode
}

No_user="$(cat /etc/RSdb | wc -l)"

menu () {
clear
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\e[41;1;37m                          ⇱  ADMINITRADOR REYCODE ⇲                     \e[0m\e[7;32m V1.3 \e[0m"
echo -e "\033[1;37m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[44;1;37m         SISTEMAS                  \e[0m" "\E[44;1;37m |                USOS                    \e[0m"
echo -e "${verde}CPU:                ${verde}RAM:      \e[0m" "\E[44;1;37m |  "
echo -e "${verde}     CUENTAS SSH - DROPLET - SCRIPT - APK MOD - DISEÑO WED (${amarillo}Reycode${cierre}${melon})
${bar4}
${blanco}TOTAL DE USUARIOS: ${rojo}>${cierre} ${azul}No: ${blanco}$No_user  ${cierre}
${bar3}
${azul}[1]${cierre} ${rojo}>${cierre} ${blanco}Agregar ===================== ${verde}Usuario${cierre}
${azul}[2]${cierre} ${rojo}>${cierre} ${blanco}Eliminar ==================== ${rojo}Usuario${cierre}
${azul}[3]${cierre} ${rojo}>${cierre} ${blanco}Editar ====================== ${amarillo}Usuario${cierre}
${azul}[4]${cierre} ${rojo}>${cierre} ${blanco}Renovar ===================== ${verde}Usuarios${cierre}
${azul}[5]${cierre} ${rojo}>${cierre} ${blanco}Detalles de los ============= ${amarillo}Usuarios${cierre}
${azul}[6]${cierre} ${rojo}>${cierre} ${blanco}Clientes ==================== ${amarillo}Onliness${cierre}
${azul}[7]${cierre} ${rojo}>${cierre} ${blanco}Actualizar ================== ${amarillo}Script${cierre}
${azul}[0]${cierre} ${rojo}>${cierre} ${rojo}SALIR${cierre}
${bar2}"
read -p "$(echo -e "${blanco}seleccione [0-5]:${cierre}")" selection
case "$selection" in
1)nuevo_usuario ;;
2)eliminar_usuario ;;
3)editar_usuario ;;
4)renovar_usuario ;;
5)detalles_de_usuario ;;
6)monit_user ;;
7)actualizar_fun ;;
	0)cd $HOME && exit 0;;
	*)
	echo -e "${rojo} Porfavor seleccione del [0-5]${cierre}"
	;;
esac
}
menu
