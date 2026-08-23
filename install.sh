#!/bin/bash
# ============================================================
# SMARTVPS - Instalación Automática Tienda de Ropa
# Versión: 4.0.0
# Uso: sudo ./install.sh
# Compatible con: Ubuntu 22.04 LTS / Debian 12
# Repositorio: https://github.com/RmXF/rsadm
# ============================================================

set -e

# ============================================================
# COLORES
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
NC='\033[0m'

# ============================================================
# VARIABLES
# ============================================================

# OBTENER IP PÚBLICA AUTOMÁTICAMENTE
IP_PUBLICA=$(curl -s ifconfig.me || curl -s icanhazip.com || curl -s ipinfo.io/ip)
if [ -z "$IP_PUBLICA" ]; then
    IP_PUBLICA=$(hostname -I | awk '{print $1}')
fi

# CONFIGURACIÓN - ¡ACTUALIZADO CON TU REPOSITORIO!
REPO_URL="https://raw.githubusercontent.com/RmXF/rsadm/main/tienda-ropa.zip"
INSTALL_DIR="/var/www/tienda-ropa"
LOG_FILE="/var/log/smartvps-install.log"
BACKEND_PORT="3000"
TEMP_DIR="/tmp/tienda-ropa-install"

# GENERAR CONTRASEÑAS
DB_PASS=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-16)
JWT_SECRET=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
ADMIN_PASS=$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-10)

# ============================================================
# FUNCIONES
# ============================================================

print_banner() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                      ║${NC}"
    echo -e "${BLUE}║  ${WHITE}███████╗███╗   ███╗ █████╗ ██████╗ ████████╗██╗   ██╗██████╗ ███████╗${BLUE}  ║${NC}"
    echo -e "${BLUE}║  ${WHITE}██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔════╝${BLUE}  ║${NC}"
    echo -e "${BLUE}║  ${WHITE}███████╗██╔████╔██║███████║██████╔╝   ██║   ██║   ██║██████╔╝███████╗${BLUE}  ║${NC}"
    echo -e "${BLUE}║  ${WHITE}╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ██║   ██║██╔═══╝ ╚════██║${BLUE}  ║${NC}"
    echo -e "${BLUE}║  ${WHITE}███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ╚██████╔╝██║     ███████║${BLUE}  ║${NC}"
    echo -e "${BLUE}║  ${WHITE}╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝     ╚══════╝${BLUE}  ║${NC}"
    echo -e "${BLUE}║                                                                      ║${NC}"
    echo -e "${BLUE}║         ${CYAN}INSTALACIÓN AUTOMÁTICA - TIENDA DE ROPA${BLUE}                   ║${NC}"
    echo -e "${BLUE}║              ${YELLOW}Versión 4.0 - SmartVPS${BLUE}                           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}  ➜ IP Pública detectada: ${CYAN}$IP_PUBLICA${NC}"
    echo -e "${GREEN}  ➜ Descargando desde: ${CYAN}$REPO_URL${NC}"
    echo -e "${GREEN}  ➜ Directorio: ${CYAN}$INSTALL_DIR${NC}"
    echo ""
}

print_step() {
    echo -e "\n${CYAN}▸▸▸ $1${NC}"
    echo -e "${BLUE}───────────────────────────────────────────────────────────────${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Este script debe ejecutarse como root"
        echo -e "${YELLOW}Usa: sudo ./install.sh${NC}"
        exit 1
    fi
}

check_os() {
    print_step "Verificando sistema operativo"
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]] && [[ "$VERSION_ID" == "22.04" ]]; then
            print_success "Ubuntu 22.04 LTS detectado"
        elif [[ "$ID" == "debian" ]] && [[ "$VERSION_ID" == "12" ]]; then
            print_success "Debian 12 detectado"
        else
            print_warning "Sistema no probado: $NAME $VERSION_ID"
            print_info "Continuando con la instalación..."
        fi
    else
        print_warning "No se pudo detectar el sistema operativo"
    fi
}

# ============================================================
# FUNCIONES DE INSTALACIÓN
# ============================================================

install_dependencies() {
    print_step "Instalando dependencias del sistema"
    
    apt update -y >> $LOG_FILE 2>&1
    apt upgrade -y >> $LOG_FILE 2>&1
    
    apt install -y curl wget git build-essential \
        software-properties-common \
        nginx postgresql postgresql-contrib \
        unzip ufw fail2ban >> $LOG_FILE 2>&1
    
    print_success "Dependencias instaladas"
}

install_nodejs() {
    print_step "Instalando Node.js 20.x"
    
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - >> $LOG_FILE 2>&1
    apt install -y nodejs >> $LOG_FILE 2>&1
    
    print_success "Node.js $(node -v) instalado"
}

install_pm2() {
    print_step "Instalando PM2"
    
    npm install -g pm2 >> $LOG_FILE 2>&1
    
    print_success "PM2 instalado"
}

setup_database() {
    print_step "Configurando base de datos PostgreSQL"
    
    sudo -u postgres psql -c "CREATE USER tienda_admin WITH PASSWORD '$DB_PASS';" >> $LOG_FILE 2>&1
    sudo -u postgres psql -c "CREATE DATABASE tienda_ropa OWNER tienda_admin;" >> $LOG_FILE 2>&1
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE tienda_ropa TO tienda_admin;" >> $LOG_FILE 2>&1
    
    print_success "Base de datos 'tienda_ropa' creada"
}

download_repo() {
    print_step "Descargando repositorio desde GitHub"
    
    # Crear directorio temporal
    rm -rf $TEMP_DIR
    mkdir -p $TEMP_DIR
    
    # Descargar ZIP
    print_info "Descargando desde: $REPO_URL"
    wget -q --show-progress -O $TEMP_DIR/repo.zip $REPO_URL || {
        print_error "Error al descargar el repositorio"
        print_info "Verifica que el repositorio exista y sea público"
        print_info "URL: $REPO_URL"
        exit 1
    }
    
    # Descomprimir
    print_info "Descomprimiendo archivos..."
    unzip -q $TEMP_DIR/repo.zip -d $TEMP_DIR
    
    # Verificar que se descomprimió correctamente
    if [ ! "$(ls -A $TEMP_DIR)" ]; then
        print_error "El ZIP está vacío o no se pudo descomprimir"
        exit 1
    fi
    
    # Buscar la carpeta extraída (puede ser tienda-ropa o tienda-ropa-main)
    EXTRACTED_DIR=$(find $TEMP_DIR -maxdepth 1 -type d -name "tienda-ropa*" | head -n 1)
    
    # Si no encuentra, buscar cualquier carpeta que no sea el directorio raíz
    if [ -z "$EXTRACTED_DIR" ]; then
        EXTRACTED_DIR=$(find $TEMP_DIR -maxdepth 1 -type d ! -path "$TEMP_DIR" | head -n 1)
    fi
    
    if [ -z "$EXTRACTED_DIR" ]; then
        print_error "No se encontró la carpeta extraída"
        print_info "Contenido de $TEMP_DIR:"
        ls -la $TEMP_DIR
        exit 1
    fi
    
    print_info "Carpeta extraída: $EXTRACTED_DIR"
    
    # Crear directorio de instalación
    mkdir -p $INSTALL_DIR
    
    # Copiar archivos
    print_info "Copiando archivos a $INSTALL_DIR"
    cp -r $EXTRACTED_DIR/* $INSTALL_DIR/ 2>/dev/null || true
    cp -r $EXTRACTED_DIR/.[!.]* $INSTALL_DIR/ 2>/dev/null || true
    
    # Verificar que se copiaron los archivos
    if [ ! -d "$INSTALL_DIR/backend" ] || [ ! -d "$INSTALL_DIR/frontend-admin" ] || [ ! -d "$INSTALL_DIR/frontend-store" ]; then
        print_error "No se encontraron las carpetas necesarias en el ZIP"
        print_info "Verifica que el ZIP contenga: backend/, frontend-admin/, frontend-store/"
        print_info "Contenido de $INSTALL_DIR:"
        ls -la $INSTALL_DIR
        exit 1
    fi
    
    # Limpiar
    rm -rf $TEMP_DIR
    
    print_success "Repositorio descargado y extraído correctamente"
}

setup_backend() {
    print_step "Configurando backend"
    
    # .env
    cat > $INSTALL_DIR/backend/.env <<EOF
PORT=$BACKEND_PORT
DB_HOST=localhost
DB_PORT=5432
DB_NAME=tienda_ropa
DB_USER=tienda_admin
DB_PASS=$DB_PASS
JWT_SECRET=$JWT_SECRET
ADMIN_PASS=$ADMIN_PASS
DOMAIN=$IP_PUBLICA
NODE_ENV=production
EOF
    
    # Instalar dependencias
    cd $INSTALL_DIR/backend
    npm install >> $LOG_FILE 2>&1
    
    # Ejecutar migraciones
    node migrations/init.js >> $LOG_FILE 2>&1
    
    print_success "Backend configurado"
}

configure_nginx() {
    print_step "Configurando Nginx"
    
    # Configuración usando IP pública
    cat > /etc/nginx/sites-available/tienda <<EOF
# ============================================================
# TIENDA DE ROPA - CONFIGURACIÓN NGINX
# IP Pública: $IP_PUBLICA
# ============================================================

# TIENDA PÚBLICA (Puerto 80)
server {
    listen 80;
    server_name $IP_PUBLICA;
    root $INSTALL_DIR/frontend-store;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:$BACKEND_PORT/api;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# PANEL ADMIN (Puerto 8080)
server {
    listen 8080;
    server_name $IP_PUBLICA;
    root $INSTALL_DIR/frontend-admin;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:$BACKEND_PORT/api;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
    
    # Habilitar sitio
    ln -sf /etc/nginx/sites-available/tienda /etc/nginx/sites-enabled/
    
    # Verificar y recargar
    nginx -t >> $LOG_FILE 2>&1
    systemctl reload nginx >> $LOG_FILE 2>&1
    
    print_success "Nginx configurado"
}

start_application() {
    print_step "Iniciando aplicación"
    
    cd $INSTALL_DIR/backend
    
    # Iniciar con PM2
    pm2 start index.js --name "tienda-backend"
    pm2 save
    pm2 startup systemd -u $SUDO_USER --hp /home/$SUDO_USER >> $LOG_FILE 2>&1
    
    print_success "Aplicación iniciada con PM2"
}

configure_firewall() {
    print_step "Configurando firewall"
    
    # Permitir puertos
    ufw allow 80/tcp >> $LOG_FILE 2>&1
    ufw allow 8080/tcp >> $LOG_FILE 2>&1
    ufw allow 22/tcp >> $LOG_FILE 2>&1
    
    # Activar si no está activo
    ufw status | grep -q "Status: active" || {
        echo "y" | ufw enable >> $LOG_FILE 2>&1
    }
    
    print_success "Firewall configurado"
}

save_credentials() {
    cat > $INSTALL_DIR/credentials.txt <<EOF
╔══════════════════════════════════════════════════════════════════╗
║              CREDENCIALES DE ACCESO - TIENDA DE ROPA            ║
╚══════════════════════════════════════════════════════════════════╝

📊 PANEL ADMINISTRATIVO:
   URL: http://$IP_PUBLICA:8080
   Contraseña: $ADMIN_PASS

🛍️  TIENDA PÚBLICA:
   URL: http://$IP_PUBLICA

🗄️  BASE DE DATOS:
   Database: tienda_ropa
   User: tienda_admin
   Password: $DB_PASS

🔐 JWT SECRET:
   $JWT_SECRET

📝 COMANDOS ÚTILES:
   Ver logs:     tail -f $LOG_FILE
   Reiniciar:    pm2 restart tienda-backend
   Ver estado:   pm2 status
   Ver creds:    cat $INSTALL_DIR/credentials.txt

════════════════════════════════════════════════════════════════════
⚠️  GUARDA ESTAS CREDENCIALES EN UN LUGAR SEGURO
════════════════════════════════════════════════════════════════════
EOF
    
    chmod 600 $INSTALL_DIR/credentials.txt
    print_success "Credenciales guardadas en $INSTALL_DIR/credentials.txt"
}

# ============================================================
# FUNCIÓN PRINCIPAL
# ============================================================

main() {
    # Verificar
    check_root
    print_banner
    
    # Iniciar log
    echo "========================================" > $LOG_FILE
    echo "SmartVPS Install - $(date)" >> $LOG_FILE
    echo "========================================" >> $LOG_FILE
    
    # Instalar
    check_os
    install_dependencies
    install_nodejs
    install_pm2
    setup_database
    download_repo
    setup_backend
    configure_nginx
    configure_firewall
    start_application
    save_credentials
    
    # ============================================================
    # FINALIZAR
    # ============================================================
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                      ║${NC}"
    echo -e "${GREEN}║         ✅  INSTALACIÓN COMPLETADA CON ÉXITO  ✅                      ║${NC}"
    echo -e "${GREEN}║                                                                      ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}📋  INFORMACIÓN DE ACCESO${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}🔑 PANEL ADMINISTRATIVO:${NC}"
    echo -e "   URL: ${CYAN}http://$IP_PUBLICA:8080${NC}"
    echo -e "   Contraseña: ${GREEN}$ADMIN_PASS${NC}"
    echo ""
    echo -e "${YELLOW}🛍️  TIENDA PÚBLICA:${NC}"
    echo -e "   URL: ${CYAN}http://$IP_PUBLICA${NC}"
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}⚠️  GUARDA ESTAS CREDENCIALES EN UN LUGAR SEGURO${NC}"
    echo -e "   Archivo: ${CYAN}$INSTALL_DIR/credentials.txt${NC}"
    echo ""
    echo -e "${BLUE}📝 COMANDOS ÚTILES:${NC}"
    echo -e "   Ver logs de instalación: ${CYAN}tail -f $LOG_FILE${NC}"
    echo -e "   Reiniciar backend:        ${CYAN}pm2 restart tienda-backend${NC}"
    echo -e "   Ver estado:               ${CYAN}pm2 status${NC}"
    echo -e "   Ver credenciales:         ${CYAN}cat $INSTALL_DIR/credentials.txt${NC}"
    echo -e "   Ver logs del backend:     ${CYAN}pm2 logs tienda-backend${NC}"
    echo ""
    echo -e "${GREEN}¡Tu tienda de ropa está lista para usar! 🎉${NC}"
    echo ""
}

# ============================================================
# EJECUTAR
# ============================================================

main "$@"
