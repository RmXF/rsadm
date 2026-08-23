#!/bin/bash
# ============================================================
# SMARTVPS - Instalación Automática Tienda de Ropa v5.0
# ============================================================
# CARACTERÍSTICAS:
#   ✅ Instalación automática de todo el sistema
#   ✅ Creación de usuario admin por defecto
#   ✅ Menú interactivo para gestionar usuarios
#   ✅ Generación de contraseñas seguras
#   ✅ Verificación de todos los servicios
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
# VARIABLES GLOBALES
# ============================================================

IP_PUBLICA=$(curl -s ifconfig.me || curl -s icanhazip.com || curl -s ipinfo.io/ip)
if [ -z "$IP_PUBLICA" ]; then
    IP_PUBLICA=$(hostname -I | awk '{print $1}')
fi

INSTALL_DIR="/var/www/tienda-ropa"
LOG_FILE="/var/log/smartvps-install.log"
BACKEND_PORT="3000"
TEMP_DIR="/tmp/tienda-ropa-install"

# Credenciales por defecto
DEFAULT_ADMIN_USER="admin"
DEFAULT_ADMIN_PASS=$(openssl rand -base64 12 | tr -d "=+/" | tr -d "[:punct:]" | cut -c1-10)

# Base de datos
DB_NAME="tienda_ropa"
DB_USER="tienda_admin"
DB_PASS=$(openssl rand -base64 16 | tr -d "=+/" | tr -d "[:punct:]" | cut -c1-16)

# JWT
JWT_SECRET=$(openssl rand -base64 32 | tr -d "=+/" | tr -d "[:punct:]" | cut -c1-32)

# ============================================================
# FUNCIONES DE UTILIDAD
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
    echo -e "${BLUE}║              ${YELLOW}Versión 5.0 - SmartVPS${BLUE}                           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}  ➜ IP Pública detectada: ${CYAN}$IP_PUBLICA${NC}"
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
    
    # Eliminar si existe
    sudo -u postgres psql -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || true
    sudo -u postgres psql -c "DROP USER IF EXISTS $DB_USER;" 2>/dev/null || true
    
    # Crear usuario y base de datos
    sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASS';" >> $LOG_FILE 2>&1
    sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" >> $LOG_FILE 2>&1
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;" >> $LOG_FILE 2>&1
    
    print_success "Base de datos '$DB_NAME' creada"
}

download_repo() {
    print_step "Descargando repositorio desde GitHub"
    
    rm -rf $TEMP_DIR
    mkdir -p $TEMP_DIR
    
    REPO_URL="https://raw.githubusercontent.com/RmXF/rsadm/main/tienda-ropa.zip"
    print_info "Descargando desde: $REPO_URL"
    
    wget -q --show-progress -O $TEMP_DIR/repo.zip $REPO_URL || {
        print_error "Error al descargar el repositorio"
        exit 1
    }
    
    print_info "Descomprimiendo archivos..."
    unzip -q $TEMP_DIR/repo.zip -d $TEMP_DIR
    
    EXTRACTED_DIR=$(find $TEMP_DIR -maxdepth 1 -type d -name "tienda-ropa*" | head -n 1)
    if [ -z "$EXTRACTED_DIR" ]; then
        EXTRACTED_DIR=$(find $TEMP_DIR -maxdepth 1 -type d ! -path "$TEMP_DIR" | head -n 1)
    fi
    
    mkdir -p $INSTALL_DIR
    cp -r $EXTRACTED_DIR/* $INSTALL_DIR/ 2>/dev/null || true
    cp -r $EXTRACTED_DIR/.[!.]* $INSTALL_DIR/ 2>/dev/null || true
    
    rm -rf $TEMP_DIR
    
    print_success "Repositorio descargado y extraído"
}

setup_backend() {
    print_step "Configurando backend"
    
    # Crear .env
    cat > $INSTALL_DIR/backend/.env <<EOF
PORT=$BACKEND_PORT
DB_HOST=localhost
DB_PORT=5432
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
JWT_SECRET=$JWT_SECRET
DOMAIN=$IP_PUBLICA
NODE_ENV=production
EOF
    
    # Instalar dependencias
    cd $INSTALL_DIR/backend
    npm install >> $LOG_FILE 2>&1
    
    # Crear tabla de usuarios
    cat > $INSTALL_DIR/backend/migrations/create_users_table.js <<'EOF'
const { Pool } = require('pg');
require('dotenv').config({ path: '../.env' });

const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'tienda_ropa',
    user: process.env.DB_USER || 'tienda_admin',
    password: String(process.env.DB_PASS || ''),
});

async function createUsersTable() {
    try {
        console.log('🔨 Creando tabla de usuarios...');
        
        await pool.query(`
            CREATE TABLE IF NOT EXISTS usuarios (
                id SERIAL PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                password VARCHAR(255) NOT NULL,
                role VARCHAR(20) DEFAULT 'admin',
                created_at TIMESTAMP DEFAULT NOW()
            );
        `);
        
        console.log('✅ Tabla de usuarios creada');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error);
        process.exit(1);
    }
}

createUsersTable();
EOF
    
    # Ejecutar migraciones
    node migrations/init.js >> $LOG_FILE 2>&1
    node migrations/create_users_table.js >> $LOG_FILE 2>&1
    
    # Crear usuario admin por defecto
    echo "🔐 Creando usuario admin por defecto..."
    node -e "
    const { Pool } = require('pg');
    const bcrypt = require('bcryptjs');
    require('dotenv').config();
    
    const pool = new Pool({
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME || 'tienda_ropa',
        user: process.env.DB_USER || 'tienda_admin',
        password: String(process.env.DB_PASS || ''),
    });
    
    async function createAdmin() {
        const username = '$DEFAULT_ADMIN_USER';
        const password = '$DEFAULT_ADMIN_PASS';
        const hashedPassword = await bcrypt.hash(password, 10);
        
        await pool.query(
            'INSERT INTO usuarios (username, password, role) VALUES (\$1, \$2, \$3) ON CONFLICT (username) DO NOTHING',
            [username, hashedPassword, 'admin']
        );
        console.log('✅ Usuario admin creado');
        process.exit(0);
    }
    createAdmin().catch(console.error);
    " >> $LOG_FILE 2>&1
    
    print_success "Backend configurado con usuario admin"
}

configure_nginx() {
    print_step "Configurando Nginx"
    
    cat > /etc/nginx/sites-available/tienda <<EOF
# TIENDA PÚBLICA
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

# PANEL ADMIN
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
    
    ln -sf /etc/nginx/sites-available/tienda /etc/nginx/sites-enabled/
    nginx -t >> $LOG_FILE 2>&1
    systemctl reload nginx >> $LOG_FILE 2>&1
    
    print_success "Nginx configurado"
}

start_application() {
    print_step "Iniciando aplicación"
    
    cd $INSTALL_DIR/backend
    
    # Matar proceso anterior si existe
    pm2 delete tienda-backend 2>/dev/null || true
    
    # Iniciar con PM2
    pm2 start index.js --name "tienda-backend" --update-env
    pm2 save
    pm2 startup systemd -u $SUDO_USER --hp /home/$SUDO_USER >> $LOG_FILE 2>&1
    
    print_success "Aplicación iniciada con PM2"
}

configure_firewall() {
    print_step "Configurando firewall"
    
    ufw allow 80/tcp >> $LOG_FILE 2>&1
    ufw allow 8080/tcp >> $LOG_FILE 2>&1
    ufw allow 22/tcp >> $LOG_FILE 2>&1
    
    ufw status | grep -q "Status: active" || {
        echo "y" | ufw enable >> $LOG_FILE 2>&1
    }
    
    print_success "Firewall configurado"
}

# ============================================================
# MENÚ DE ADMINISTRACIÓN DE USUARIOS
# ============================================================

manage_users() {
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}👥  GESTIÓN DE USUARIOS DEL PANEL${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}1)${NC} Agregar nuevo usuario admin"
    echo -e "${YELLOW}2)${NC} Listar usuarios existentes"
    echo -e "${YELLOW}3)${NC} Eliminar usuario"
    echo -e "${YELLOW}4)${NC} Cambiar contraseña de usuario"
    echo -e "${YELLOW}5)${NC} Salir"
    echo ""
    
    read -p "Selecciona una opción [1-5]: " option
    
    case $option in
        1)
            add_user
            ;;
        2)
            list_users
            ;;
        3)
            delete_user
            ;;
        4)
            change_password
            ;;
        5)
            echo -e "${GREEN}¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Opción inválida${NC}"
            manage_users
            ;;
    esac
}

add_user() {
    echo ""
    echo -e "${CYAN}➕ Agregar nuevo usuario${NC}"
    echo -e "${BLUE}─────────────────────────────${NC}"
    
    read -p "Nombre de usuario: " username
    if [ -z "$username" ]; then
        echo -e "${RED}El nombre de usuario no puede estar vacío${NC}"
        add_user
        return
    fi
    
    read -sp "Contraseña: " password
    echo ""
    if [ -z "$password" ]; then
        echo -e "${RED}La contraseña no puede estar vacía${NC}"
        add_user
        return
    fi
    
    read -sp "Confirmar contraseña: " password2
    echo ""
    
    if [ "$password" != "$password2" ]; then
        echo -e "${RED}Las contraseñas no coinciden${NC}"
        add_user
        return
    fi
    
    cd $INSTALL_DIR/backend
    node -e "
    const { Pool } = require('pg');
    const bcrypt = require('bcryptjs');
    require('dotenv').config();
    
    const pool = new Pool({
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME || 'tienda_ropa',
        user: process.env.DB_USER || 'tienda_admin',
        password: String(process.env.DB_PASS || ''),
    });
    
    async function addUser() {
        const hashedPassword = await bcrypt.hash('$password', 10);
        try {
            await pool.query(
                'INSERT INTO usuarios (username, password, role) VALUES (\$1, \$2, \$3)',
                ['$username', hashedPassword, 'admin']
            );
            console.log('✅ Usuario creado exitosamente');
            process.exit(0);
        } catch (error) {
            if (error.code === '23505') {
                console.log('❌ El usuario ya existe');
            } else {
                console.log('❌ Error:', error.message);
            }
            process.exit(1);
        }
    }
    addUser();
    "
    
    echo ""
    read -p "Presiona Enter para continuar..."
    manage_users
}

list_users() {
    echo ""
    echo -e "${CYAN}📋 Lista de usuarios${NC}"
    echo -e "${BLUE}─────────────────────────────${NC}"
    
    cd $INSTALL_DIR/backend
    node -e "
    const { Pool } = require('pg');
    require('dotenv').config();
    
    const pool = new Pool({
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME || 'tienda_ropa',
        user: process.env.DB_USER || 'tienda_admin',
        password: String(process.env.DB_PASS || ''),
    });
    
    async function listUsers() {
        const result = await pool.query('SELECT id, username, role, created_at FROM usuarios ORDER BY id');
        if (result.rows.length === 0) {
            console.log('No hay usuarios registrados');
        } else {
            console.log('ID | Usuario | Rol | Creado');
            console.log('─────────────────────────────────────');
            result.rows.forEach(u => {
                console.log(\`\${u.id} | \${u.username} | \${u.role} | \${new Date(u.created_at).toLocaleString()}\`);
            });
        }
        process.exit(0);
    }
    listUsers();
    "
    
    echo ""
    read -p "Presiona Enter para continuar..."
    manage_users
}

delete_user() {
    echo ""
    echo -e "${CYAN}🗑️  Eliminar usuario${NC}"
    echo -e "${BLUE}─────────────────────────────${NC}"
    
    read -p "Nombre de usuario a eliminar: " username
    
    if [ "$username" == "$DEFAULT_ADMIN_USER" ]; then
        echo -e "${RED}No puedes eliminar el usuario admin por defecto${NC}"
        read -p "Presiona Enter para continuar..."
        manage_users
        return
    fi
    
    cd $INSTALL_DIR/backend
    node -e "
    const { Pool } = require('pg');
    require('dotenv').config();
    
    const pool = new Pool({
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME || 'tienda_ropa',
        user: process.env.DB_USER || 'tienda_admin',
        password: String(process.env.DB_PASS || ''),
    });
    
    async function deleteUser() {
        const result = await pool.query('DELETE FROM usuarios WHERE username = \$1 RETURNING *', ['$username']);
        if (result.rows.length > 0) {
            console.log('✅ Usuario eliminado');
        } else {
            console.log('❌ Usuario no encontrado');
        }
        process.exit(0);
    }
    deleteUser();
    "
    
    echo ""
    read -p "Presiona Enter para continuar..."
    manage_users
}

change_password() {
    echo ""
    echo -e "${CYAN}🔑 Cambiar contraseña${NC}"
    echo -e "${BLUE}─────────────────────────────${NC}"
    
    read -p "Nombre de usuario: " username
    
    read -sp "Nueva contraseña: " password
    echo ""
    if [ -z "$password" ]; then
        echo -e "${RED}La contraseña no puede estar vacía${NC}"
        change_password
        return
    fi
    
    read -sp "Confirmar contraseña: " password2
    echo ""
    
    if [ "$password" != "$password2" ]; then
        echo -e "${RED}Las contraseñas no coinciden${NC}"
        change_password
        return
    fi
    
    cd $INSTALL_DIR/backend
    node -e "
    const { Pool } = require('pg');
    const bcrypt = require('bcryptjs');
    require('dotenv').config();
    
    const pool = new Pool({
        host: process.env.DB_HOST || 'localhost',
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME || 'tienda_ropa',
        user: process.env.DB_USER || 'tienda_admin',
        password: String(process.env.DB_PASS || ''),
    });
    
    async function changePassword() {
        const hashedPassword = await bcrypt.hash('$password', 10);
        const result = await pool.query(
            'UPDATE usuarios SET password = \$1 WHERE username = \$2 RETURNING *',
            [hashedPassword, '$username']
        );
        if (result.rows.length > 0) {
            console.log('✅ Contraseña actualizada');
        } else {
            console.log('❌ Usuario no encontrado');
        }
        process.exit(0);
    }
    changePassword();
    "
    
    echo ""
    read -p "Presiona Enter para continuar..."
    manage_users
}

# ============================================================
# FUNCIÓN PRINCIPAL
# ============================================================

main() {
    check_root
    print_banner
    
    # Iniciar log
    echo "========================================" > $LOG_FILE
    echo "SmartVPS Install v5.0 - $(date)" >> $LOG_FILE
    echo "========================================" >> $LOG_FILE
    
    # Instalación automática
    install_dependencies
    install_nodejs
    install_pm2
    setup_database
    download_repo
    setup_backend
    configure_nginx
    configure_firewall
    start_application
    
    # ============================================================
    # FINALIZAR
    # ============================================================
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         ✅  INSTALACIÓN COMPLETADA CON ÉXITO  ✅                      ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}📋  INFORMACIÓN DE ACCESO${NC}"
    echo -e "${PURPLE}══════════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YEL
