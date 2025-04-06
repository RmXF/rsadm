#!/bin/bash

# === CONFIGURACIÓN INICIAL ===
COLOR_TEXTO="\e[32m"
COLOR_LINEAS="\e[34m"
COLOR_NUMEROS="\e[36m"
RESET="\e[0m"

# === FUNCIONES ===

function cambiar_colores() {
  echo -e "${COLOR_TEXTO}Seleccione nuevo color para el texto (ej: \e[31m Rojo, \e[32m Verde):${RESET}"
  read -rp "Código ANSI: " COLOR_TEXTO
  echo -e "${COLOR_TEXTO}Seleccione nuevo color para las líneas:${RESET}"
  read -rp "Código ANSI: " COLOR_LINEAS
  echo -e "${COLOR_TEXTO}Seleccione nuevo color para los números:${RESET}"
  read -rp "Código ANSI: " COLOR_NUMEROS
}

function mostrar_usuarios() {
  echo -e "${COLOR_LINEAS}╔════════════╦════════════════════╦══════════════╗"
  echo -e "║  ${COLOR_TEXTO}Usuario    ${COLOR_LINEAS}║ ${COLOR_TEXTO}Fecha Expiración ${COLOR_LINEAS}║ ${COLOR_TEXTO}Estado       ${COLOR_LINEAS}║"
  echo -e "╠════════════╬════════════════════╬══════════════╣"

  for user in $(cut -d: -f1 /etc/passwd); do
    exp=$(chage -l "$user" 2>/dev/null | grep "Account expires" | cut -d: -f2 | xargs)
    estado=$(passwd -S "$user" 2>/dev/null | awk '{print $2}')
    if [[ "$estado" == "P" ]]; then estado="Activo"; else estado="Inactivo"; fi
    printf "${COLOR_LINEAS}║ ${COLOR_TEXTO}%-10s ${COLOR_LINEAS}║ ${COLOR_TEXTO}%-18s ${COLOR_LINEAS}║ ${COLOR_TEXTO}%-12s ${COLOR_LINEAS}║\n" "$user" "$exp" "$estado"
  done

  echo -e "${COLOR_LINEAS}╚════════════╩════════════════════╩══════════════╝${RESET}"
}

function monitoreo() {
  echo -e "${COLOR_TEXTO}Uso de CPU:${RESET} $(top -bn1 | grep \"Cpu(s)\" | awk '{print $2 + $4}')%"
  echo -e "${COLOR_TEXTO}Uso de RAM:${RESET} $(free -m | awk '/Mem:/ { printf(\"%.2f%%\", $3/$2 * 100) }')"
  echo -e "${COLOR_TEXTO}Espacio en disco:${RESET}"
  df -h | grep "^/dev" | awk '{print $1, $5, $6}'
}

function crear_usuario() {
  read -rp "Nombre de usuario: " user
  read -rp "Días válidos: " dias
  sudo useradd -e $(date -d "$dias days" +"%Y-%m-%d") -M -s /bin/false "$user"
  echo "$user" | passwd --stdin "$user" 2>/dev/null || echo -e "Ingrese contraseña para $user manualmente."
  echo -e "${COLOR_TEXTO}Usuario $user creado por $dias días.${RESET}"
}

function enviar_alerta() {
  # Simulación: Puedes conectar esto con curl + webhook Telegram o Discord
  echo -e "${COLOR_TEXTO}[ALERTA] Evento registrado. (Simulado)${RESET}"
}

# === MENÚ PRINCIPAL ===

while true; do
  echo -e "${COLOR_LINEAS}============== ${COLOR_NUMEROS}PROYECTO VPS ${COLOR_LINEAS}==============${RESET}"
  echo -e "${COLOR_NUMEROS}1${RESET}) Mostrar usuarios"
  echo -e "${COLOR_NUMEROS}2${RESET}) Crear nuevo usuario"
  echo -e "${COLOR_NUMEROS}3${RESET}) Monitoreo de sistema"
  echo -e "${COLOR_NUMEROS}4${RESET}) Enviar alerta (test)"
  echo -e "${COLOR_NUMEROS}5${RESET}) Cambiar colores"
  echo -e "${COLOR_NUMEROS}0${RESET}) Salir"
  echo -ne "${COLOR_TEXTO}Seleccione una opción:${RESET} "
  read -r opt

  case "$opt" in
    1) mostrar_usuarios ;;
    2) crear_usuario ;;
    3) monitoreo ;;
    4) enviar_alerta ;;
    5) cambiar_colores ;;
    0) exit ;;
    *) echo "Opción inválida." ;;
  esac
done
