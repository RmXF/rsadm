#!/bin/bash
clear
cd $HOME
SCPdir="/etc/newadm"
SCPinstal="$HOME/install"
SCPidioma="${SCPdir}/idioma"
SCPusr="${SCPdir}/ger-user"
SCPfrm="/etc/ger-frm"
SCPinst="/etc/ger-inst"
service apache2 restart > /dev/null 2>&1
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;
mkdir -p /etc/B-ADMuser &>/dev/null
rm -rf /etc/localtime &>/dev/null
ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime &>/dev/null
rm $(pwd)/$0 &> /dev/null
msg () {
BRAN='\033[1;37m' && VERMELHO='\e[31m' && VERDE='\e[32m' && AMARELO='\e[33m'
AZUL='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' &&NEGRITO='\e[1m' && SEMCOR='\e[0m'
case $1 in
-ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
-ama)cor="${AMARELO}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
-verm)cor="${AMARELO}${NEGRITO}[!] ${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
-azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
-verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
-bra)cor="${VERMELHO}" && echo -ne "${cor}${2}${SEMCOR}";;
"-bar2"|"-bar")cor="${VERMELHO}══════════════════════════════════════════════════════════" && echo -e "${SEMCOR}${cor}${SEMCOR}";;
esac
}
mm_decho ()
{
local i stepping
stepping="0.01"
if [ ! "$1" ]; then
echo
return
fi
if (( $# > 1 )) &&
[[ ($2 = $(echo $2 | grep -oE '[[:digit:]]')) ||
($2 = $(echo $2 | grep -oE '[[:digit:]]+\.[[:digit:]]+')) ]]
then
stepping="$2"
elif (( $# > 1 )); then
echo "$1"
echo ".! mm_decho() oops: second argument is invalid!" 1>&2
echo ".! must be /float but is: \"$2\", leaving function.." 1>&2
return false 2>/dev/null
fi
for i in $(seq 0 $((${#1}-1))); do
echo -ne "${1:$i:1}"
sleep $stepping
done
echo
}
msg -bar
echo -e "\033[97m"
echo -e "\033[100m      INSTALACION DE PAQUETES NECESARIOS PARA CODE RS..   "
echo -e "\033[97m"
msg -bar
apt-get install grep -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "grep"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "grep"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install grep............ $ESTATUS "
apt-get install net-tools -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "net-tools"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "net-tools"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install net-tools....... $ESTATUS "
apt-get install gawk -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "gawk"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "gawk"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install gawk............ $ESTATUS "
apt-get install mlocate -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "mlocate"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "mlocate"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install mlocate......... $ESTATUS "
apt-get install lolcat -y &>/dev/null
sudo gem install lolcat &>/dev/null
[[ $(dpkg --get-selections|grep -w "lolcat"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "lolcat"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install lolcat.......... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "at"|head -1) ]] || apt-get install at -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "at"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "at"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install at.............. $ESTATUS "
[[ $(dpkg --get-selections|grep -w "nano"|head -1) ]] || apt-get install nano -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "nano"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "nano"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install nano............ $ESTATUS "
[[ $(dpkg --get-selections|grep -w "bc"|head -1) ]] || apt-get install bc -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "bc"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "bc"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install bc.............. $ESTATUS "
[[ $(dpkg --get-selections|grep -w "lsof"|head -1) ]] || apt-get install lsof -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "lsof"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "lsof"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install lsof............ $ESTATUS "
[[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || apt-get install figlet -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "figlet"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install figlet.......... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "cowsay"|head -1) ]] || apt-get install cowsay -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "cowsay"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "cowsay"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install cowsay.......... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "screen"|head -1) ]] || apt-get install screen -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "screen"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "screen"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install screen.......... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "python"|head -1) ]] || apt-get install python -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "python"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "python"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install python.......... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "python3"|head -1) ]] || apt-get install python3 -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "python3"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "python3"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install python3......... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "python3-pip"|head -1) ]] || apt-get install python3-pip -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "python3-pip"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "python3-pip"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install python3-pip..... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "curl"|head -1) ]] || apt-get install curl -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "curl"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "curl"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install curl............ $ESTATUS "
[[ $(dpkg --get-selections|grep -w "ufw"|head -1) ]] || apt-get install ufw -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "ufw"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "ufw"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install ufw............. $ESTATUS "
[[ $(dpkg --get-selections|grep -w "unzip"|head -1) ]] || apt-get install unzip -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "unzip"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "unzip"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install unzip........... $ESTATUS "
[[ $(dpkg --get-selections|grep -w "zip"|head -1) ]] || apt-get install zip -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "zip"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "zip"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install zip............. $ESTATUS "
[[ $(dpkg --get-selections|grep -w "apache2"|head -1) ]] || {
apt-get install apache2 -y &>/dev/null
sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf
service apache2 restart > /dev/null 2>&1 &
}
[[ $(dpkg --get-selections|grep -w "apache2"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "apache2"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m    # apt-get install apache2......... $ESTATUS "
msg -bar2
echo -e "\033[1;39m Preciona Enter Para continuar"
clear
idfix64_86 () {
msg -bar2
echo -e "ENCASO DE PEDIR ALGUNA INSTALACION ESCOJA: y "
apt-get update; apt-get upgrade -y
apt-get install curl -y
apt-get install lsof -y
apt-get install sudo -y
apt-get install figlet -y
apt-get install cowsay -y
apt-get install bc -y
apt-get install python -y
apt-get install at
sed -i "s;Listen 80;Listen 81;g" /etc/apache2/ports.conf
service apache2 restart
clear
msg -bar2
echo -e "ESCOJER PRIMERO #All locales# Y LUEGO #en_US.UTF-8# "
sleep 7s
export LANGUAGE=en_US.UTF-8\
&& export LANG=en_US.UTF-8\
&& export LC_ALL=en_US.UTF-8\
&& export LC_CTYPE="en_US.UTF-8"\
&& locale-gen en_US.UTF-8\
&& sudo apt-get -y install language-pack-en-base\
&& sudo dpkg-reconfigure locales
clear
}
msg -bar2
echo -e "\033[1;97m  ¿PRECENTO ALGUN ERROR ALGUN PAQUETE ANTERIOR?"
msg -bar2
echo -e "\033[1;32m 1- Escoja:(N) No. Para Instalacion Normal"
echo -e "\033[1;31m 2- Escoja:(S) Si. Saltaron errores."
msg -bar2
echo -e "\033[1;39m Al preciona enter continuara la instalacion Normal"
msg -bar2
read -p " [ S | N ]: " idfix64_86
[[ "$idfix64_86" = "s" || "$idfix64_86" = "S" ]] && idfix64_86
clear
fun_ip () {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
}

funcao_idioma () {
figlet " REYCODESSH " | lolcat
msg -bar2
pv="$(echo es)"
[[ ${#id} -gt 2 ]] && id="es" || id="$pv"
byinst="true"
}
install_fim () {
msg -ama "               Finalizando Instalacion" && msg bar2
[[ $(find /etc/newadm/ger-user -name nombre.log|grep -w "nombre.log"|head -1) ]] || wget -O /etc/newadm/ger-user/nombre.log https://www.dropbox.com/s/482g5nz346co512/nombre.log?dl=0 &>/dev/null
[[ $(find /etc/newadm/ger-user -name IDT.log|grep -w "IDT.log"|head -1) ]] || wget -O /etc/newadm/ger-user/IDT.log https://www.dropbox.com/s/7f7byzmeyvphyud/IDT.log &>/dev/null
[[ $(find /etc/newadm/ger-user -name tiemlim.log|grep -w "tiemlim.log"|head -1) ]] || wget -O /etc/newadm/ger-user/tiemlim.log https://www.dropbox.com/s/kx8jrnzx7xypme0/tiemlim.log &>/dev/null
wget -O /etc/versin_script_new https://www.dropbox.com/s/chcuehkzf8a59lo/Vercion &>/dev/null
wget -O /bin/Desbloqueo.sh https://www.dropbox.com/s/91gyh29kuyuaf2p/Desbloqueo.sh &> /dev/null
chmod +x /bin/Desbloqueo.sh
wget -O /bin/rebootnb https://www.dropbox.com/s/gdld00a6haol6ok/rebootnb &> /dev/null
chmod +x /bin/rebootnb 
wget -O /bin/resetsshdrop https://www.dropbox.com/s/9icdqse187r4xde/resetsshdrop &> /dev/null
chmod +x /bin/resetsshdrop
wget -O /bin/monitor.sh https://www.dropbox.com/s/8ecwun7zea51niu/monitor.sh &> /dev/null
chmod +x /bin/monitor.sh
msg -bar2
echo '#!/bin/sh -e' > /etc/rc.local
sudo chmod +x /etc/rc.local
echo "sudo rebootnb" >> /etc/rc.local
echo "sudo resetsshdrop" >> /etc/rc.local
echo "sleep 2s" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
/bin/cp /etc/skel/.bashrc ~/
echo -e "         COMANDO PRINCIPAL PARA ENTRAR AL PANEL "
echo -e "\033[1;41m                       usercode                         \033[0;37m" && msg -bar2
sleep 1
}
ofus () {
unset server
server=$(echo ${txt_ofuscatw}|cut -d':' -f1)
unset txtofus
number=$(expr length $1)
for((i=1; i<$number+1; i++)); do
txt[$i]=$(echo "$1" | cut -b $i)
case ${txt[$i]} in
".")txt[$i]="+";;
"+")txt[$i]=".";;
"1")txt[$i]="@";;
"@")txt[$i]="1";;
"2")txt[$i]="?";;
"?")txt[$i]="2";;
"4")txt[$i]="%";;
"%")txt[$i]="4";;
"-")txt[$i]="K";;
"K")txt[$i]="-";;
esac
txtofus+="${txt[$i]}"
done
echo "$txtofus" | rev
}
verificar_arq () {
[[ ! -d ${SCPdir} ]] && mkdir ${SCPdir}
[[ ! -d ${SCPusr} ]] && mkdir ${SCPusr}
[[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
[[ ! -d ${SCPinst} ]] && mkdir ${SCPinst}
case $1 in
"menu"|"message.txt")ARQ="${SCPdir}/";; #Menu
"usercodes")ARQ="${SCPusr}/";; #Panel SSRR
"C-SSR.sh")ARQ="${SCPinst}/";; #Instalacao
"openssh.sh")ARQ="${SCPinst}/";; #Instalacao
"squid.sh")ARQ="${SCPinst}/";; #Instalacao
"dropbear.sh")ARQ="${SCPinst}/";; #Instalacao
"openvpn.sh")ARQ="${SCPinst}/";; #Instalacao
"ssl.sh")ARQ="${SCPinst}/";; #Instalacao
"shadowsocks.sh")ARQ="${SCPinst}/";; #Instalacao
"Shadowsocks-libev.sh")ARQ="${SCPinst}/";; #Instalacao
"Shadowsocks-R.sh")ARQ="${SCPinst}/";; #Instalacao
"v2ray.sh")ARQ="${SCPinst}/";; #Instalacao
"budp.sh")ARQ="${SCPinst}/";; #Instalacao
"sockspy.sh"|"PDirect.py"|"PPub.py"|"PPriv.py"|"POpen.py"|"PGet.py")ARQ="${SCPinst}/";; #Instalacao
*)ARQ="${SCPfrm}/";; #Ferramentas
esac
mv -f ${SCPinstal}/$1 ${ARQ}/$1
chmod +x ${ARQ}/$1
msg -bar2
echo -e "\033[97m"
echo -e "\033[100m                        RS-CREACIONES                    "
echo -e "\033[97m"
msg -bar2
[[ $1 = "" ]] && funcao_idioma || {
[[ ${#1} -gt 2 ]] && funcao_idioma || id="$1"
}

LINK="https://github.com/RmXF/rsadm/blob/main/arqs.zip"
TEMP="$HOME/$RANDOM" && [[ ! -d ${TEMP} ]] && mkdir ${TEMP}
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && mkdir ${SCPdir}
SCPusr="${SCPdir}/ger-user" && [[ ! -d ${SCPusr} ]] && mkdir ${SCPusr}
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
SCPfrm3="/etc/adm-lite" && [[ ! -d ${SCPfrm} ]] && mkdir ${SCPfrm}
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && mkdir ${SCPinst}
SCPidioma="${SCPdir}/idioma"
echo
wget ${LINK} -O $HOME/ADM -o /dev/null && mm_decho "===[ REYCODESSH ]===" "0.08"
echo -e "$BARRA"
cd ${TEMP} && unzip $HOME/ADM && echo -e "$BARRA" && mm_decho "EXITO EN INSTALACION!" "0.08"
echo -e "$BARRA"
echo -e "${COLOR[0]}INSTALANDO..."
echo -e "$BARRA"
echo -ne "${COLOR[3]}["
for arq in `ls ${TEMP}`; do
echo -ne "${COLOR[1]}X" && sleep 0.2s
case $arq in
"trans")mv -f /usr/bin/trans;;
"panelrs.sh")mv -f ${TEMP}/$arq ${SCPusr}/$arq && chmod +x ${SCPusr}/$arq;;
*)mv -f ${TEMP}/$arq ${SCPdir}/$arq && chmod +x ${SCPdir}/$arq;;
esac
done && rm -rf ${TEMP}
echo -e "${COLOR[3]}]"
cat << EOF > /bin/usercode
cd ${SCPdir} && ./usercode
EOF
cat << EOF > /bin/usercode
cd ${SCPdir} && ./usercode
EOF
chmod +x /bin/adm && chmod +x /bin/usercode
rm $HOME/ADM > /dev/null 2>&1
rm $HOME/$0  > /dev/null 2>&1
updatedb
cat /etc/bash.bashrc|grep -v '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' > /etc/bash.bashrc.2
echo -e '[[ $UID != 0 ]] && TMOUT=15 && export TMOUT' >> /etc/bash.bashrc.2
mv -f /etc/bash.bashrc.2 /etc/bash.bashrc
[[ ${#id} -gt 2 ]] && echo "es" > ${SCPidioma} || echo "${id}" > ${SCPidioma}
msg -bar2
[[ ${byinst} = "true" ]] && install_fim
rm -rf instalador.sh