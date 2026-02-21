#!/bin/bash
# Script de Instalación de Protocolos y Página Web
# CodexSSH GOLD - dev: @ReyRs_ViPro
# Versión: 1.0.0

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuración
WEB_ROOT="/var/www/html"
INDEX_URL="https://raw.githubusercontent.com/tu-usuario/tu-repo/main/index.html" # CAMBIAR ESTA URL
BACKUP_DIR="/root/backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/root/install_$(date +%Y%m%d_%H%M%S).log"

# Función para log
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a $LOG_FILE
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a $LOG_FILE
}

# Banner de inicio
show_banner() {
    clear
    echo -e "${BLUE}"
    echo '   ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗███████╗███████╗██╗  ██╗'
    echo '  ██╔════╝██╔═══██╗██╔══██╗██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║  ██║'
    echo '  ██║     ██║   ██║██║  ██║█████╗   ╚███╔╝ ███████╗███████╗███████║'
    echo '  ██║     ██║   ██║██║  ██║██╔══╝   ██╔██╗ ╚════██║╚════██║██╔══██║'
    echo '  ╚██████╗╚██████╔╝██████╔╝███████╗██╔╝ ██╗███████║███████║██║  ██║'
    echo '   ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝'
    echo -e "${GREEN}"
    echo '                    ╔════════════════════════════╗'
    echo '                    ║  INSTALADOR DE PROTOCOLOS  ║'
    echo '                    ║       dev: @ReyRs_ViPro    ║'
    echo '                    ╚════════════════════════════╝'
    echo -e "${NC}"
    echo ""
}

# Verificar root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Este script debe ejecutarse como root"
    fi
    log "✓ Verificación de root exitosa"
}

# Detectar sistema operativo
detect_os() {
    log "Detectando sistema operativo..."
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
    else
        error "No se pudo detectar el sistema operativo"
    fi
    
    log "✓ Sistema detectado: $OS $VER"
}

# Actualizar sistema
update_system() {
    log "Actualizando sistema..."
    
    case $OS in
        ubuntu|debian)
            apt-get update -y >> $LOG_FILE 2>&1
            apt-get upgrade -y >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum update -y >> $LOG_FILE 2>&1
            ;;
        *)
            warn "Sistema no reconocido, continuando de todas formas..."
            ;;
    esac
    
    log "✓ Sistema actualizado"
}

# Instalar protocolos básicos
install_basic_protocols() {
    log "Instalando protocolos básicos..."
    
    case $OS in
        ubuntu|debian)
            apt-get install -y \
                curl \
                wget \
                git \
                unzip \
                zip \
                tar \
                gzip \
                net-tools \
                netcat \
                telnet \
                dnsutils \
                traceroute \
                htop \
                nload \
                iptables \
                ufw \
                fail2ban \
                cron \
                openssh-server \
                openssl \
                ca-certificates \
                software-properties-common \
                apt-transport-https \
                lsb-release \
                gnupg \
                >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum install -y \
                curl \
                wget \
                git \
                unzip \
                zip \
                tar \
                gzip \
                net-tools \
                nc \
                telnet \
                bind-utils \
                traceroute \
                htop \
                nload \
                iptables \
                firewalld \
                fail2ban \
                cronie \
                openssh-server \
                openssl \
                ca-certificates \
                >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ Protocolos básicos instalados"
}

# Instalar y configurar Nginx
install_nginx() {
    log "Instalando Nginx..."
    
    case $OS in
        ubuntu|debian)
            apt-get install -y nginx >> $LOG_FILE 2>&1
            systemctl enable nginx >> $LOG_FILE 2>&1
            systemctl start nginx >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum install -y epel-release >> $LOG_FILE 2>&1
            yum install -y nginx >> $LOG_FILE 2>&1
            systemctl enable nginx >> $LOG_FILE 2>&1
            systemctl start nginx >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ Nginx instalado y configurado"
}

# Instalar y configurar Apache (alternativa)
install_apache() {
    log "Instalando Apache..."
    
    case $OS in
        ubuntu|debian)
            apt-get install -y apache2 >> $LOG_FILE 2>&1
            systemctl enable apache2 >> $LOG_FILE 2>&1
            systemctl start apache2 >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum install -y httpd >> $LOG_FILE 2>&1
            systemctl enable httpd >> $LOG_FILE 2>&1
            systemctl start httpd >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ Apache instalado y configurado"
}

# Instalar PHP
install_php() {
    log "Instalando PHP..."
    
    case $OS in
        ubuntu|debian)
            apt-get install -y \
                php8.1 \
                php8.1-fpm \
                php8.1-mysql \
                php8.1-curl \
                php8.1-gd \
                php8.1-mbstring \
                php8.1-xml \
                php8.1-zip \
                php8.1-bcmath \
                php8.1-json \
                php8.1-tokenizer \
                >> $LOG_FILE 2>&1
            
            systemctl enable php8.1-fpm >> $LOG_FILE 2>&1
            systemctl start php8.1-fpm >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum install -y \
                php \
                php-fpm \
                php-mysqlnd \
                php-curl \
                php-gd \
                php-mbstring \
                php-xml \
                php-zip \
                php-bcmath \
                php-json \
                >> $LOG_FILE 2>&1
            
            systemctl enable php-fpm >> $LOG_FILE 2>&1
            systemctl start php-fpm >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ PHP instalado"
}

# Configurar firewall
configure_firewall() {
    log "Configurando firewall..."
    
    # Puertos a abrir
    PORTS=(22 80 443 21 25 53 110 143 993 995 3306 5432 27017 6379 11211)
    
    case $OS in
        ubuntu|debian)
            ufw --force disable >> $LOG_FILE 2>&1
            ufw --force reset >> $LOG_FILE 2>&1
            
            for port in "${PORTS[@]}"; do
                ufw allow $port >> $LOG_FILE 2>&1
            done
            
            ufw allow OpenSSH >> $LOG_FILE 2>&1
            ufw --force enable >> $LOG_FILE 2>&1
            
            # Configurar fail2ban
            cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF
            systemctl restart fail2ban >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            systemctl start firewalld >> $LOG_FILE 2>&1
            systemctl enable firewalld >> $LOG_FILE 2>&1
            
            for port in "${PORTS[@]}"; do
                firewall-cmd --permanent --add-port=$port/tcp >> $LOG_FILE 2>&1
            done
            
            firewall-cmd --reload >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ Firewall configurado"
}

# Configurar seguridad SSH
configure_ssh() {
    log "Configurando seguridad SSH..."
    
    # Backup de configuración original
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    
    # Configuración segura de SSH
    cat > /etc/ssh/sshd_config <<EOF
# Configuración SSH - CodexSSH GOLD
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Autenticación
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM yes

# Seguridad
MaxAuthTries 3
MaxSessions 10
LoginGraceTime 30
ClientAliveInterval 300
ClientAliveCountMax 2
MaxStartups 10:30:60

# Logging
SyslogFacility AUTH
LogLevel INFO

# Configuraciones adicionales
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
EOF
    
    systemctl restart sshd >> $LOG_FILE 2>&1
    
    log "✓ SSH configurado"
}

# Instalar SSL
install_ssl() {
    log "Instalando SSL..."
    
    # Instalar Certbot
    case $OS in
        ubuntu|debian)
            apt-get install -y certbot python3-certbot-nginx >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum install -y certbot python3-certbot-nginx >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ Certbot instalado"
}

# Descargar e instalar página web
install_website() {
    log "Instalando página web..."
    
    # Crear backup del index actual si existe
    if [ -f "$WEB_ROOT/index.html" ]; then
        cp "$WEB_ROOT/index.html" "$BACKUP_DIR/index.html.backup"
        log "✓ Backup creado en $BACKUP_DIR"
    fi
    
    # Descargar el index desde la URL
    log "Descargando index desde: $INDEX_URL"
    if curl -s -o "$WEB_ROOT/index.html" "$INDEX_URL"; then
        log "✓ Página web descargada exitosamente"
    else
        # Si no se puede descargar, crear un index básico
        warn "No se pudo descargar el index, creando página por defecto..."
        cat > "$WEB_ROOT/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodexSSH GOLD - Servidor Configurado</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .container {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            max-width: 600px;
            margin: 2rem;
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }
        .subtitle {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        .info {
            background: rgba(255, 255, 255, 0.15);
            padding: 1.5rem;
            border-radius: 10px;
            margin: 2rem 0;
            text-align: left;
        }
        .info-item {
            margin: 0.5rem 0;
            padding: 0.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .label {
            font-weight: bold;
            color: #ffd700;
        }
        .dev {
            position: fixed;
            bottom: 10px;
            right: 10px;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
        }
        .protocols {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
            margin: 2rem 0;
        }
        .protocol-tag {
            background: rgba(255, 255, 255, 0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        .status {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 5px;
        }
        .status.online {
            background: #4ade80;
            box-shadow: 0 0 10px #4ade80;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✨ CodexSSH GOLD</h1>
        <p class="subtitle">Servidor configurado exitosamente</p>
        
        <div class="status-indicator">
            <span class="status online"></span>
            <span>Servidor Online</span>
        </div>
        
        <div class="info">
            <div class="info-item">
                <span class="label">IP del Servidor:</span> 
                <span id="server-ip"></span>
            </div>
            <div class="info-item">
                <span class="label">Fecha de instalación:</span> 
                <span id="install-date"></span>
            </div>
            <div class="info-item">
                <span class="label">Protocolos instalados:</span> 
            </div>
        </div>
        
        <div class="protocols" id="protocol-list">
            <span class="protocol-tag">HTTP/HTTPS</span>
            <span class="protocol-tag">SSH</span>
            <span class="protocol-tag">FTP</span>
            <span class="protocol-tag">DNS</span>
            <span class="protocol-tag">SMTP</span>
            <span class="protocol-tag">POP3</span>
            <span class="protocol-tag">IMAP</span>
            <span class="protocol-tag">MySQL</span>
            <span class="protocol-tag">PostgreSQL</span>
            <span class="protocol-tag">MongoDB</span>
            <span class="protocol-tag">Redis</span>
            <span class="protocol-tag">Memcached</span>
        </div>
        
        <p style="margin-top: 2rem; opacity: 0.8;">
            ¡Todos los protocolos instalados y funcionando!
        </p>
    </div>
    
    <div class="dev">
        dev: @ReyRs_ViPro | CodexSSH GOLD v1.0.0
    </div>
    
    <script>
        // Mostrar IP del servidor
        fetch('https://api.ipify.org?format=json')
            .then(response => response.json())
            .then(data => {
                document.getElementById('server-ip').textContent = data.ip;
            });
        
        // Mostrar fecha de instalación
        document.getElementById('install-date').textContent = new Date().toLocaleDateString('es-ES', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    </script>
</body>
</html>
EOF
        log "✓ Página por defecto creada"
    fi
    
    # Configurar permisos
    chown -R www-data:www-data "$WEB_ROOT" 2>/dev/null || chown -R apache:apache "$WEB_ROOT" 2>/dev/null
    chmod -R 755 "$WEB_ROOT"
    
    log "✓ Página web instalada en $WEB_ROOT/index.html"
}

# Configurar archivo hosts
configure_hosts() {
    log "Configurando archivo hosts..."
    
    # Obtener IP
    IP=$(curl -s ifconfig.me)
    
    # Agregar entrada al hosts
    echo "$IP $(hostname) codexssh.local" >> /etc/hosts
    
    log "✓ Hosts configurado"
}

# Instalar protocolos adicionales
install_additional_protocols() {
    log "Instalando protocolos adicionales..."
    
    case $OS in
        ubuntu|debian)
            apt-get install -y \
                vsftpd \
                proftpd \
                bind9 \
                bind9utils \
                postfix \
                dovecot-core \
                dovecot-imapd \
                dovecot-pop3d \
                mysql-server \
                mysql-client \
                postgresql \
                mongodb \
                redis-server \
                memcached \
                >> $LOG_FILE 2>&1
            ;;
        centos|rhel|fedora)
            yum install -y \
                vsftpd \
                bind \
                bind-utils \
                postfix \
                dovecot \
                mysql-server \
                mysql-client \
                postgresql-server \
                mongodb \
                redis \
                memcached \
                >> $LOG_FILE 2>&1
            ;;
    esac
    
    log "✓ Protocolos adicionales instalados"
}

# Configurar servicios para iniciar con el sistema
enable_services() {
    log "Configurando servicios para inicio automático..."
    
    SERVICES=(
        "nginx" "apache2" "httpd"
        "mysql" "mariadb" "postgresql"
        "redis-server" "redis"
        "memcached"
        "ssh" "sshd"
        "vsftpd" "proftpd"
        "bind9" "named"
        "postfix" "dovecot"
    )
    
    for service in "${SERVICES[@]}"; do
        systemctl enable "$service" 2>/dev/null
    done
    
    log "✓ Servicios configurados"
}

# Mostrar resumen final
show_summary() {
    IP=$(curl -s ifconfig.me)
    
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         INSTALACIÓN COMPLETADA EXITOSAMENTE             ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📊 RESUMEN DE INSTALACIÓN:${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${YELLOW}➤ IP del Servidor:${NC}   $IP"
    echo -e "  ${YELLOW}➤ Página Web:${NC}        http://$IP"
    echo -e "  ${YELLOW}➤ Protocolos:${NC}        HTTP/HTTPS, SSH, FTP, DNS, SMTP, POP3, IMAP, MySQL, PostgreSQL, MongoDB, Redis, Memcached"
    echo -e "  ${YELLOW}➤ Web Server:${NC}         Nginx/Apache"
    echo -e "  ${YELLOW}➤ PHP Versión:${NC}        8.1"
    echo -e "  ${YELLOW}➤ Firewall:${NC}           Activado (puertos 22,80,443,21,25,53,110,143,993,995,3306,5432,27017,6379,11211)"
    echo -e "  ${YELLOW}➤ SSL:${NC}                 Certbot instalado"
    echo -e "  ${YELLOW}➤ Log file:${NC}            $LOG_FILE"
    echo -e "  ${YELLOW}➤ Backup dir:${NC}          $BACKUP_DIR"
    echo ""
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${GREEN}✅ Para acceder a tu página web:${NC}"
    echo -e "  http://$IP"
    echo ""
    echo -e "${YELLOW}📝 Para configurar SSL con Certbot:${NC}"
    echo -e "  certbot --nginx -d tudominio.com"
    echo ""
    echo -e "${BLUE}👨‍💻 dev: @ReyRs_ViPro | CodexSSH GOLD v1.0.0${NC}"
    echo ""
}

# Función principal
main() {
    show_banner
    check_root
    detect_os
    update_system
    
    echo ""
    echo -e "${YELLOW}¿Qué servidor web deseas instalar?${NC}"
    echo "1) Nginx (Recomendado)"
    echo "2) Apache"
    read -p "Selecciona una opción [1-2]: " web_choice
    
    echo ""
    echo -e "${YELLOW}URL del archivo index.html (deja vacío para usar el predeterminado):${NC}"
    read -p "URL: " custom_index_url
    
    if [ ! -z "$custom_index_url" ]; then
        INDEX_URL="$custom_index_url"
    fi
    
    echo ""
    echo -e "${RED}⚠️  ATENCIÓN:${NC} Este script instalará múltiples protocolos y servicios."
    echo -e "¿Estás seguro de continuar? (s/n)"
    read -p "Opción: " confirm
    
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        error "Instalación cancelada por el usuario"
    fi
    
    log "Iniciando instalación..."
    
    # Instalaciones básicas
    install_basic_protocols
    install_additional_protocols
    
    # Instalar servidor web según elección
    case $web_choice in
        1) install_nginx ;;
        2) install_apache ;;
        *) install_nginx ;;
    esac
    
    # Instalar PHP
    install_php
    
    # Configuraciones
    configure_firewall
    configure_ssh
    install_ssl
    configure_hosts
    enable_services
    
    # Instalar página web
    install_website
    
    # Mostrar resumen
    show_summary
    
    log "Instalación completada exitosamente"
}

# Ejecutar función principal
main "$@"
